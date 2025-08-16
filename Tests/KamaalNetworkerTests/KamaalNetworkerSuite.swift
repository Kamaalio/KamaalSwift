//
//  KamaalNetworkerSuite.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Testing
import Foundation

@testable import KamaalNetworker

@Suite("KamaalNetworker Suite", .serialized)
struct KamaalNetworkerSuite {
    private let apiURL = URL(string: "https://kamaal.io")!
    private let networker: KamaalNetworker

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        self.networker = KamaalNetworker(urlSession: urlSession)
    }

    @Test("Makes successful requests")
    func makesSuccessfulRequests() async throws {
        let statusCode = 200
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: apiURL, statusCode: statusCode, httpVersion: nil, headerFields: nil,
            )!
            let jsonString = """
            {
                "message": "yes"
            }
            """
            let data = jsonString.data(using: .utf8)
            return (response, data)
        }

        let result: Result<Response<MockResponse>, KamaalNetworker.Errors> =
            await networker.request(from: self.apiURL)
        let response = try result.get()

        #expect(response.data == MockResponse(message: "yes"))
        #expect(response.status == statusCode)
    }

    @Test("Makes failing requests")
    func makesFailingRequests() async throws {
        let statusCode = 400
        let jsonString = """
        {
            "message": "oh nooooo!"
        }
        """
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: apiURL, statusCode: statusCode, httpVersion: nil, headerFields: nil,
            )!

            let data = jsonString.data(using: .utf8)
            return (response, data)
        }

        let result: Result<Response<MockResponse>, KamaalNetworker.Errors> =
            await networker.request(from: self.apiURL)

        #expect(
            throws: KamaalNetworker.Errors.responseError(message: jsonString, code: 400),
            "Should throw when API fails",
            performing: { try result.get() },
        )
    }
}

struct MockResponse: Decodable, Hashable {
    let message: String
}

class MockURLProtocol: URLProtocol {
    nonisolated(unsafe) static var requestHandler:
        ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with _: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let handler = MockURLProtocol.requestHandler!

        let (response, data): (HTTPURLResponse, Data?)
        do {
            (response, data) = try handler(request)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        if let data {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
