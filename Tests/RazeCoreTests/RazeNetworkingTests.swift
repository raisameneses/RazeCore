//
//  RazeNetworkingTests.swift
//  RazeCoreTests
//
//  Created by Raisa Meneses on 1/19/21.
//

import XCTest
@testable import RazeCore
class NetworkSessionMock : NetworkSession {
    var data: Data?
    var error: Error?
    func get(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(data, error)
    }
    func post(with request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(data, error)
    }
    
}
struct mockData: Codable, Equatable {
    var id: Int
    var name: String
}
final class RazeNetworkingTests: XCTestCase {
    func testLoadDataCall(){
        let manager = RazeCore.Networking.Manager()
        let session = NetworkSessionMock()
        manager.session = session
        let expectation = XCTestExpectation(description: "Called for data")
        
        let data = Data([0, 1, 0, 1])
        session.data = data
        let url = URL(fileURLWithPath: "url")
        manager.loadData(from: url){ result in
            expectation.fulfill()
            switch result {
            case .success(let returnedData):
                XCTAssertEqual(data, returnedData, "Manager returned unexpected data")
            case .failure(let error):
                XCTFail(error?.localizedDescription ?? "Error forming error result")
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    func testSendDataCall(){
        let manager = RazeCore.Networking.Manager()
        let session = NetworkSessionMock()
        let sampleObject = mockData(id: 1, name: "David")
        let data = try? JSONEncoder().encode(sampleObject)
        session.data = data
        manager.session = session
        let url = URL(fileURLWithPath: "url")
        let expectation = XCTestExpectation(description: "send data")
        manager.sendData(to: url, body: sampleObject){ result in
            expectation.fulfill()
            switch result {
            case .success(let returnedData):
                JSONDecoder.decode(mockData.self, from: returnedData)
                XCTAssertEqual(sampleObject, returnedData)
                break
            case .error(let error):
                XCTFail(error?.localizedDesription ?? "Error forming error result")
            }
            
        }
        wait(for: [expectation], timeout: 5)
    }
    static var allTests = [
        ("testLoadDataCall", testLoadDataCall),
        ("testSendDataCall", testSendDataCall)
    ]
}
