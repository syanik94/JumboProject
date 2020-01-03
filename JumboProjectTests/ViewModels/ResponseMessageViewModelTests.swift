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

    override func setUp() {
        sut = makeSUT()
    }

    override func tearDown() {
        
    }
    
    func testInitialState() {
        let expectedOutput = ResponseMessageViewModel.State.loading
        
        XCTAssertEqual(sut!.state, expectedOutput)
    }
    
    
    func testLoadingState() {
        let expectedOutput = ResponseMessageViewModel.State.loading
        
        sut!.handleStateChanges(state: "", progress: 11)
        
        XCTAssertEqual(sut!.state, expectedOutput)
        XCTAssertEqual(sut!.progress, 11)
        
        sut!.handleStateChanges(state: "", progress: 72)

        XCTAssertEqual(sut!.state, expectedOutput)
        XCTAssertEqual(sut!.progress, 72)
        
        sut!.handleStateChanges(state: "", progress: 95)

        XCTAssertEqual(sut!.state, expectedOutput)
        XCTAssertEqual(sut!.progress, 95)
    }
    
    func testSuccess() {
        let expectedOutput = ResponseMessageViewModel.State.success
        
        sut!.handleStateChanges(state: "success", progress: 95)
        
        XCTAssertEqual(sut!.state, expectedOutput)
        XCTAssertEqual(sut!.progress, 100)
    }

    func testError() {
        let expectedOutput = ResponseMessageViewModel.State.error
        
        sut!.handleStateChanges(state: "error", progress: 95)
        
        XCTAssertEqual(sut!.state, expectedOutput)
        XCTAssertEqual(sut!.progress, 95)
    }
    
    // MARK: - Helpers
    
    fileprivate func makeSUT() -> ResponseMessageViewModel {
        let message = ResponseMessage(id: "test")
        return ResponseMessageViewModel(responseMessage: message)
    }
    
}
