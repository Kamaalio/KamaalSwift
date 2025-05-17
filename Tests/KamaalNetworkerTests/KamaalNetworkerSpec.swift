//
//  KamaalNetworkerSpec.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Quick
import Nimble
import Foundation
@testable import KamaalNetworker

final class KamaalNetworkerSpec: QuickSpec {
    override func spec() {
        describe("request") {
            let apiURL = URL(string: "https://kamaal.io")!
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            let urlSession = URLSession(configuration: configuration)
            let networker = KamaalNetworker(urlSession: urlSession)

            context("Make succesfull requests") {
                it("makes requests") {
                    let statusCode = 200
                    MockURLProtocol.requestHandler = { _ in
                        let response = HTTPURLResponse(
                            url: apiURL,
                            statusCode: statusCode,
                            httpVersion: nil,
                            headerFields: nil
                        )!

                        let jsonString = """
                        {
                            "message": "yes"
                        }
                        """
                        let data = jsonString.data(using: .utf8)
                        return (response, data)
                    }

                    let expectation = self.expectation(description: "Expectation")
                    Task {
                        let result: Result<Response<MockResponse>, KamaalNetworker.Errors> = await networker
                            .request(from: apiURL)
                        let response = try result.get()
                        expect(response.data) == MockResponse(message: "yes")
                        expect(response.status) == statusCode

                        expectation.fulfill()
                    }

                    self.wait(for: [expectation], timeout: 2)
                }
            }

            context("Make failing requests") {
                it("fails requests") {
                    let statusCode = 400
                    let jsonString = """
                    {
                        "message": "oh nooooo!"
                    }
                    """

                    MockURLProtocol.requestHandler = { _ in
                        let response = HTTPURLResponse(
                            url: apiURL,
                            statusCode: statusCode,
                            httpVersion: nil,
                            headerFields: nil
                        )!

                        let data = jsonString.data(using: .utf8)
                        return (response, data)
                    }

                    let expectation = self.expectation(description: "Expectation")
                    Task {
                        let result: Result<Response<MockResponse>, KamaalNetworker.Errors> = await networker
                            .request(from: apiURL)
                        expect { try result.get() }.to(throwError { error in
                            let castedError = error as! KamaalNetworker.Errors
                            expect(castedError) == .responseError(message: jsonString, code: 400)
                            expectation.fulfill()
                        })
                    }

                    self.wait(for: [expectation], timeout: 2)
                }
            }
        }
    }
}

struct MockResponse: Decodable, Hashable {
    let message: String
}

class MockURLProtocol: URLProtocol {
    nonisolated(unsafe) static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

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
