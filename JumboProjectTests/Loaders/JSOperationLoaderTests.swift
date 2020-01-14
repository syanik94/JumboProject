//
//  JSOperationLoaderTests.swift
//  JumboProjectTests
//
//  Created by Yanik Simpson on 1/14/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import JumboProject

class JSOperationLoaderTests: XCTestCase {

    var sut: JSOperationLoader!
    
    func testDelegateNotRetained() {
        sut = JSOperationLoader()
        var delegate = MockOperationDelegate()
        sut.delegate = delegate
        
        XCTAssertNotNil(sut.delegate)
        
        delegate = MockOperationDelegate()
        XCTAssertNil(sut.delegate)
    }
}
class MockOperationDelegate: JSOperationLoaderDelegate {
      func didLoadJavascriptResponse(with response: ResponseCompletion) {}
      func didReceiveError(error: JSLoaderError) {}
  }
