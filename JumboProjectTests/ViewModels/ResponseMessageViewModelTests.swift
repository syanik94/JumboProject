//
//  JumboProjectTests.swift
//  JumboProjectTests
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import JumboProject

class ResponseMessageViewModelTests: XCTestCase {

    var sut: ResponseMessageViewModel!
    
    func testInitialState() {
        sut = makeSUT(responseCompletion: (0, ""))
        let expectedOutput = ResponseMessageViewModel.State.loading

        XCTAssertNotNil(sut.loader)
        sut.load()
        
        XCTAssertEqual(sut.state, expectedOutput)
    }
    
    func testLoadingState() {
        sut = makeSUT(responseCompletion: (32, ""))
        let expectedOutput = ResponseMessageViewModel.State.loading
        let testExpectation = expectation(description: #function)
        
        sut.updateHandler = { (id) in
            XCTAssertEqual(id, "test", "ID should match ResponseMessage.id")
            print(self.sut.state)
            if self.sut.state == .loading { testExpectation.fulfill() }
        }
        sut.load()
        
        wait(for: [testExpectation], timeout: 1)
        XCTAssertEqual(sut.state, expectedOutput)
        XCTAssertEqual(sut.progress.completedUnitCount, 32)
    }
    
    func testSuccessState() {
        sut = makeSUT(responseCompletion: (32, "success"))
        let expectedOutput = ResponseMessageViewModel.State.success
        let testExpectation = expectation(description: #function)
        
        sut.updateHandler = { (id) in
            XCTAssertEqual(id, "test", "ID should match ResponseMessage.id")
            if self.sut.state == .success { testExpectation.fulfill() }
        }
        sut.load()
        
        wait(for: [testExpectation], timeout: 1)
        XCTAssertEqual(sut.state, expectedOutput)
        XCTAssertEqual(sut.progress.completedUnitCount, 100)
    }
    
    func testErrorWithInvalidStateText() {
        sut = makeSUT(responseCompletion: (32, "err"))
        let expectedOutput = ResponseMessageViewModel.State.error(type: .invalidStateString)
        let testExpectation = expectation(description: #function)
        
        sut.updateHandler = { (id) in
            XCTAssertEqual(id, "test", "ID should match ResponseMessage.id")
            if self.sut.state == .error(type: .invalidStateString) { testExpectation.fulfill() }
        }
        sut.load()
        
        wait(for: [testExpectation], timeout: 1)
        XCTAssertEqual(sut.state, expectedOutput)
        XCTAssertEqual(sut.progress.completedUnitCount, 32)
    }
        
    func testRetainCycle() {
        let completion = (progress: 32, state: "")
        let message = ResponseMessage(id: "test")
        var loader = MockLoader(responseCompletion: completion)
        
        sut = ResponseMessageViewModel(responseMessage: message, jsLoader: loader)
        XCTAssertNotNil(sut.loader)
        loader = MockLoader(responseCompletion: completion)
        
        XCTAssertNil(sut.loader)
    }
    
    // MARK: - Helpers
    
    fileprivate func makeSUT(responseCompletion: ResponseCompletion) -> ResponseMessageViewModel {
        let message = ResponseMessage(id: "test")
        let mockLoader = MockLoader(responseCompletion: responseCompletion)
        let vm = ResponseMessageViewModel(responseMessage: message, jsLoader: mockLoader)
        return vm
    }
}

fileprivate typealias ResponseCompletion = (progress: Int, state: String)
class MockLoader: JSOperationLoaderProtocol {
    weak var delegate: JSOperationLoaderDelegate?
    fileprivate let responseCompletion: ResponseCompletion
    
    fileprivate init(responseCompletion: ResponseCompletion) {
        self.responseCompletion = responseCompletion
    }
    
    func load(with id: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.delegate?.didLoad(with: self.responseCompletion)
        }
    }
}
