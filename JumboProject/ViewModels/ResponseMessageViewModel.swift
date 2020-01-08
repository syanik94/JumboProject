//
//  ResponseMessageViewModel.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

enum JSLoaderError: Error {
    case operationFailure
    case invalidStateString
    case javascriptEvaluationFailure
    case invalidUrl
    case messageCastToStringFailure
    case dataConversionFailure
    case networkFailure
    case jsonDecodingError
    
    var localizedDescription: String {
        switch self {
        case .operationFailure:
            return "Javascript operation failure"
        case .invalidStateString:
            return "Invalid state string"
        case .javascriptEvaluationFailure:
            return "Failed to evaluate Javascript"
        case .invalidUrl:
            return "Invalid URL"
        case .messageCastToStringFailure:
            return "Error casting message response to String"
        case .dataConversionFailure:
            return "Failed to convert String to Data"
        case .networkFailure:
            return "Failed to navigate to URL"
        case .jsonDecodingError:
            return "JSON Decoding Error"
        }
    }
}

final class ResponseMessageViewModel {    
    enum State: Equatable {
        case pending
        case loading
        case error(type: JSLoaderError)
        case success
        
        static func getState(from stateString: String) -> State {
            if stateString == "success" {
                return .success
            }
            else if stateString == "error" {
                return .error(type: .operationFailure)
            } else {
                return .error(type: .invalidStateString)
            }
        }
    }
    
    var updateHandler: (String) -> Void = {_ in }
    
    let id: String
    let progress = Progress(totalUnitCount: 100)
    var state: State = .pending
    weak var loader: JSOperationLoaderProtocol?

    init(responseMessage: ResponseMessage,
         jsLoader: JSOperationLoaderProtocol = JSOperationLoader()) {
        self.id = responseMessage.id
        self.loader = jsLoader
        loader?.delegate = self
    }
    
    func load() {
        state = .loading
        loader?.load(with: id)
    }
}

// MARK: - JSOperationLoaderDelegate Methods

extension ResponseMessageViewModel: JSOperationLoaderDelegate {
    func didLoad(with response: ResponseCompletion) {
        progress.completedUnitCount = Int64(response.progress)
        state = response.state.isEmpty ? state : State.getState(from: response.state)
        if state == .success { progress.completedUnitCount = Int64(100) }
        updateHandler(id)
    }
    
    func didReceiveError(error: JSLoaderError) {
        self.state = .error(type: error)
        updateHandler(id)
    }
}

