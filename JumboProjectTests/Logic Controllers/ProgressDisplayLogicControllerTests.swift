//
//  ProgressDisplayLogicControllerTests.swift
//  JumboProjectTests
//
//  Created by Yanik Simpson on 1/14/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import JumboProject

class ProgressDisplayLogicControllerTests: XCTestCase {

    var sut: ProgressDisplayLogicController!
    
    func testInitialState() {
        sut = makeSUT()
        
        XCTAssertTrue(sut.responseMessageViewModels.isEmpty)
    }
    
    func testCreateViewModels() {
        sut = makeSUT()
        
        sut.createResponseMessageViewModels()
        
        XCTAssertEqual(sut.responseMessageViewModels.count, 1)
    }
    
    func testIfLoaderRetained() {
        var loader = MockJSLoader()
        let sut = ProgressDisplayLogicController(jsLoader: loader)
        
        XCTAssertNotNil(sut.jsLoader)
        loader = MockJSLoader()
        
        XCTAssertNil(sut.jsLoader)
    }
    

    // MARK: - Helpers
    
    func makeSUT() -> ProgressDisplayLogicController {
        let mockJSLoader = MockJSLoader()
        let logicController = ProgressDisplayLogicController(jsLoader: mockJSLoader)
        logicController.numberOfResponseMessages = 1
        return logicController
    }
}

class MockJSLoader: JSOperationLoaderProtocol {
    weak var delegate: JSOperationLoaderDelegate?
    
    var ids: [String] = []
    
    func load() {
        
//        delegate?.didLoad(with: <#T##(id: String, progress: Int, state: String)#>)
    }
}
