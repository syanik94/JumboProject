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

        XCTAssertEqual(sut.responseMessageViewModels.count, 1)
        XCTAssertEqual(sut.viewModelLookup.count, 1)
        XCTAssertEqual(sut.responseMessageViewModels.map { $0.id }, ["test"])
    }
    
    func testJSOperationLoadResponse() {
        sut = makeSUT()

        sut.configureJSOperationLoader()

        XCTAssertEqual(sut.responseMessageViewModels[0].state, ResponseMessageViewModel.State.success)
    }

    // MARK: - Helpers
    
    func makeSUT() -> ProgressDisplayLogicController {
        let mockJSLoader = MockJSLoader()
        let logicController = ProgressDisplayLogicController(ids: ["test"], jsLoader: mockJSLoader)
        return logicController
    }
}

class MockJSLoader: JSOperationLoaderProtocol {
    weak var delegate: JSOperationLoaderDelegate?
    var ids: [String] = []
    
    func load() {
        let response = (id: "test", progress: 95, state: "success")
        delegate?.didLoadJavascriptResponse(with: response)
    }
}
