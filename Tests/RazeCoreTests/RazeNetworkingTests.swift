//
//  RazeNetworkingTests.swift
//  RazeCoreTests
//
//  Created by Borko Tomic on 28/05/2020.
//

import XCTest
@testable import RazeCore

class NetworkSessionMock: NetworkSession {
    var data: Data?
    var error: Error?
    func get(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        completion(data, error)
    }
    
    func post(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        completion(data, error)
    }
}

struct MockData: Codable, Equatable {
    var id: Int
    var name: String
}

final class RazeNetworkingTests: XCTestCase {
    
    func testLoadDataCall() {
        let manager = RazeCore.Networking.Manager()
        let session = NetworkSessionMock()
        manager.session = session
        let expectation = XCTestExpectation(description: "Called for data")
        let data = Data([0, 1, 0, 1])
        session.data = data
        
        let url = URL(fileURLWithPath: "url")
        manager.loadData(from: url) { result in
            expectation.fulfill()
            switch result {
            case .success(let returnedData):
                XCTAssertEqual(data, returnedData, "manager returned unexpected data")
            case .failure(let error):
                XCTFail(error?.localizedDescription ?? "Error forming error result")
            }
        }
        wait(for: [expectation], timeout: 5)
    }

    func testSendDataCall() {
        let manager = RazeCore.Networking.Manager()
        let session = NetworkSessionMock()
        let sampleObject = MockData(id: 1, name: "Daavid")
        let data = try? JSONEncoder().encode(sampleObject)
        session.data = data
        manager.session = session
        let url = URL(fileURLWithPath: "url")
        let expectation = XCTestExpectation(description: "Sent data")
        manager.sendData(to: url, with: sampleObject) { result in
            expectation.fulfill()
            switch result {
            case .success(let returnedData):
                let returnedObject = try? JSONDecoder().decode(MockData.self, from: returnedData)
                XCTAssertEqual(returnedObject, sampleObject)
            case .failure(let error):
                XCTFail(error?.localizedDescription ?? "error forming error result")
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    static var allTests = [
        ("testLoadDataCall", testLoadDataCall),
        ("testSendDataCall", testSendDataCall)
    ]
        
}
