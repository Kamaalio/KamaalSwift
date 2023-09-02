//
//  Store.swift
//
//
//  Created by Kamaal M Farah on 17/12/2022.
//

import StoreKit
import Foundation
import KamaalLogger
import KamaalExtensions

/// ViewModel to handle donations logic.
final class Store: NSObject, ObservableObject {
    /// Loading state. View should indicate there is a proccess loading.
    @Published private(set) var isLoading = false
    /// Requested donations from StoreKit.
    @Published private(set) var donations: [CustomProduct] = []
    /// Purchasing state. View should indicate user is currently purchasing.
    @Published private(set) var isPurchasing = false

    private var storeKitDonations: [StoreKitDonation.ID: StoreKitDonation]!
    private var purchasedIdentifiersToTimesPurchased: [String: Int] = [:]
    private var updateListenerTask: Task<Void, Never>?
    private var purchasingTask: Task<Void, Never>?
    private var products: [Product] = []
    private var productFetcher: ProductFetcher!
    private let logger = KamaalLogger(from: Store.self)

    override private init() { }

    init(donations: [StoreKitDonation], productFetcher: ProductFetcher = StoreKitProductFetcher()) {
        super.init()

        self.storeKitDonations = donations.mappedByID
        self.updateListenerTask = self.listenForTransactions()
        self.productFetcher = productFetcher
    }

    deinit {
        updateListenerTask?.cancel()
    }

    enum Errors: Error {
        case failedVerification
        case getProducts
        case purchaseError(causeError: Error?)
        case noTransactionMade
        case canNotMakePayment
    }

    var hasDonations: Bool {
        !self.donations.isEmpty
    }

    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments() && (!self.isLoading || !self.isPurchasing)
    }

    func purchaseDonation(_ donation: CustomProduct, completion: @escaping (Result<Transaction, Errors>) -> Void) {
        guard self.canMakePayments, let foundProduct = products.find(by: \.id, is: donation.id) else {
            completion(.failure(.canNotMakePayment))
            return
        }

        self.purchasingTask?.cancel()
        self.purchasingTask = Task {
            let result = await verifyAndPurchase(foundProduct)
            let transaction: Transaction
            switch result {
            case let .failure(failure):
                self.logger.error(label: "failed to verify or purchase product", error: failure)
                completion(.failure(failure))
                return
            case let .success(success):
                transaction = success
            }

            completion(.success(transaction))
        }
    }

    func requestProducts() async -> Result<Void, Errors> {
        guard !self.hasDonations, !self.storeKitDonations.isEmpty else { return .success(()) }

        self.logger.info("requesting products")

        return await self.withLoading(completion: {
            let productsResult = await getProducts()
            let donations: [CustomProduct]
            switch productsResult {
            case let .failure(failure):
                return .failure(failure)
            case let .success(success):
                donations = success
            }

            await self.setDonations(donations)
            self.products = donations.compactMap(\.product)
            return .success(())
        })
    }

    private func getProducts() async -> Result<[CustomProduct], Errors> {
        let products: [CustomProduct]
        do {
            products = try await self.productFetcher.getProducts(by: self.storeKitDonations)
        } catch {
            self.logger.error(label: "failed to get products", error: error)
            return .failure(.getProducts)
        }

        let donations = products
            .sorted(by: \.weight, using: .orderedAscending)
        return .success(donations)
    }

    @MainActor
    private func setDonations(_ donations: [CustomProduct]) {
        self.donations = donations
    }

    @MainActor
    private func withLoading<T>(completion: () async -> T) async -> T {
        self.isLoading = true
        let result = await completion()
        self.isLoading = false
        return result
    }

    @MainActor
    private func withIsPurchasing<T>(completion: () async -> T) async -> T {
        self.isPurchasing = true
        let result = await completion()
        self.isPurchasing = false
        return result
    }

    private func productToCustomProduct(_ product: Product) -> CustomProduct? {
        let displayName = product.displayName

        guard !displayName.isEmpty,
              product.type == .consumable,
              let donationItem = storeKitDonations[product.id] else { return nil }

        return CustomProduct(product: product, emoji: donationItem.emojiCharacter, weight: donationItem.weight)
    }

    /// Update transactions regularly on a detached task for whenever the user makes a transaction outside of the app
    /// - Returns: a Task result that does not return anything and does not fail
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            guard let self, !self.storeKitDonations.isEmpty else { return }

            // Iterate through any transactions which didn't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                let transaction: Transaction
                switch self.checkVerified(result) {
                case let .failure(failure):
                    self.logger.error(label: "failed to verify transaction", error: failure)
                    continue
                case let .success(success):
                    transaction = success
                }

                await self.updatePurchasedIdentifiers(transaction)
                await transaction.finish()
            }
        }
    }

    private func verifyAndPurchase(_ product: Product) async -> Result<Transaction, Errors> {
        await self.withIsPurchasing(completion: {
            await self.withLoading(completion: {
                self.logger.info("purchasing product with id \(product.id)")

                let purchaseResult: Product.PurchaseResult
                do {
                    purchaseResult = try await product.purchase()
                } catch {
                    self.logger.error(label: "failed to purchase product", error: error)
                    return .failure(.purchaseError(causeError: error))
                }

                let verification: VerificationResult<Transaction>
                switch purchaseResult {
                case .pending, .userCancelled: return .failure(.noTransactionMade)
                case let .success(success): verification = success
                default: return .failure(.noTransactionMade)
                }

                let transaction: Transaction
                switch self.checkVerified(verification) {
                case let .failure(failure):
                    return .failure(failure)
                case let .success(success):
                    transaction = success
                }

                await self.updatePurchasedIdentifiers(transaction)
                await transaction.finish()
                self.logger.info("successfully purchased product with id \(transaction.productID)")
                return .success(transaction)
            })
        })
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) -> Result<T, Errors> {
        switch result {
        // StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
        case .unverified: return .failure(.failedVerification)
        // If the transaction is verified, unwrap and return it.
        case let .verified(safe): return .success(safe)
        }
    }

    private func updatePurchasedIdentifiers(_ transaction: Transaction) async {
        let productID = transaction.productID
        if transaction.revocationDate == nil {
            // If the App Store has not revoked the transaction, add it to the list of `purchasedIdentifiers`.
            self.incrementPurchasedIdentifiers(by: 1, toIdentifier: productID)
        } else {
            // If the App Store has revoked this transaction, remove it from the list of `purchasedIdentifiers`.
            self.incrementPurchasedIdentifiers(by: -1, toIdentifier: productID)
        }
    }

    private func incrementPurchasedIdentifiers(by increment: Int, toIdentifier identifier: String) {
        let value = self.purchasedIdentifiersToTimesPurchased[identifier] ?? 0
        if increment < 0, value < 1 {
            return
        }

        self.purchasedIdentifiersToTimesPurchased[identifier] = value + increment
    }
}

protocol ProductFetcher {
    func getProducts(by storeKitDonations: [StoreKitDonation.ID: StoreKitDonation]) async throws -> [CustomProduct]
}

struct StoreKitProductFetcher: ProductFetcher {
    func getProducts(by storeKitDonations: [StoreKitDonation.ID: StoreKitDonation]) async throws -> [CustomProduct] {
        let productIDs = storeKitDonations
            .map(\.value.id)
        let products = try await Product.products(for: productIDs)
        return products.compactMap { product -> CustomProduct? in
            let displayName = product.displayName

            guard !displayName.isEmpty,
                  product.type == .consumable,
                  let donationItem = storeKitDonations[product.id] else { return nil }

            return CustomProduct(product: product, emoji: donationItem.emojiCharacter, weight: donationItem.weight)
        }
    }
}
