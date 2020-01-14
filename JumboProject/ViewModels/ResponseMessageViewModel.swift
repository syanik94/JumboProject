//
//  ResponseMessageViewModel.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

enum JSLoaderError: Error, Equatable {
    case operationFailure
    case invalidStateString(state: String)
    case javascriptEvaluationFailure
    case invalidUrl(urlString: String)
    case messageCastToStringFailure
    case dataConversionFailure
    case networkFailure
    case jsonDecodingError
    
    var localizedDescription: String {
        switch self {
        case .operationFailure:
            return "Javascript operation failure"
        case .invalidStateString(let state):
            return "Invalid state string" + state
        case .javascriptEvaluationFailure:
            return "Failed to evaluate Javascript"
        case .invalidUrl(let urlString):
            return "Invalid URL" + urlString
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
                return .error(type: .invalidStateString(state: stateString))
            }
        }
    }
    
    let id: String
    let progress = Progress(totalUnitCount: 100)
    var state: State = .pending

    init(responseMessage: ResponseMessage) {
        self.id = responseMessage.id
        state = .loading
    }
    
    func updateState(from response: ResponseCompletion) {
        progress.completedUnitCount = Int64(response.progress)
        state = response.state.isEmpty ? state : ResponseMessageViewModel.State.getState(from: response.state)
        if state == .success { progress.completedUnitCount = Int64(100) }
    }
}

