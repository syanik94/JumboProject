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
    
    let id: String
    let progress = Progress(totalUnitCount: 100)
    var state: State = .pending
    
    init(responseMessage: ResponseMessage) {
        self.id = responseMessage.id
        self.state = .loading
    }
    
    func handleStateChanges(state: String, progress: Int) {
        if progress != 0 { self.progress.completedUnitCount = Int64(progress) }
        self.state = state.isEmpty ? self.state : State.getState(from: state)
        if self.state == .success { self.progress.completedUnitCount = Int64(100) }
    }
}

