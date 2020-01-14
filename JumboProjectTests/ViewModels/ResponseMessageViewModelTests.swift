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
        sut = makeSUT()
        
        let expectedOutput = ResponseMessageViewModel.State.loading

        XCTAssertEqual(sut.state, expectedOutput)
    }
    
    func testLoadingState() {
        sut = makeSUT()
        let expectedStateOutput = ResponseMessageViewModel.State.loading

        let initialResponseCompletion = ("test", 11, "")
        
        sut.updateState(from: initialResponseCompletion)
        
        XCTAssertEqual(sut.state, expectedStateOutput)
        XCTAssertEqual(sut.progress.completedUnitCount, 11)
        
        let secondResponseCompletion = ("test", 32, "")
        sut.updateState(from: secondResponseCompletion)

        XCTAssertEqual(sut.state, expectedStateOutput)
        XCTAssertEqual(sut.progress.completedUnitCount, 32)
    }

    func testSuccessState() {
        sut = makeSUT()
        let expectedStateOutput = ResponseMessageViewModel.State.success
        
        let successResponseCompletion = ("test", 95, "success")
        sut.updateState(from: successResponseCompletion)
        
        XCTAssertEqual(sut.state, expectedStateOutput)
        XCTAssertEqual(sut.progress.completedUnitCount, 100)
    }
    
    func testErrorFromOperationFailure() {
        sut = makeSUT()
        let expectedStateOutput = ResponseMessageViewModel.State.error(type: .operationFailure)
        
        let errorResponseCompletion = ("test", 95, "error")
        sut.updateState(from: errorResponseCompletion)
        
        XCTAssertEqual(sut.state, expectedStateOutput)
        XCTAssertEqual(sut.progress.completedUnitCount, 95)
    }
    
    func testErrorFromInvalidStateString() {
        sut = makeSUT()
        let expectedStateOutput = ResponseMessageViewModel.State.error(type: .invalidStateString(state: "succ"))
        
        let attemptedSuccessResponseCompletion = ("test", 95, "succ")
        sut.updateState(from: attemptedSuccessResponseCompletion)
        
        XCTAssertEqual(sut.state, expectedStateOutput)
        XCTAssertEqual(sut.progress.completedUnitCount, 95)
    }

    // MARK: - Helpers

    fileprivate func makeSUT() -> ResponseMessageViewModel {
        let message = ResponseMessage(id: "test")
        let vm = ResponseMessageViewModel(responseMessage: message)
        return vm
    }
}
