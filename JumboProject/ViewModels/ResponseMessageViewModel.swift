//
//  ResponseMessageViewModel.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class ResponseMessageViewModel {
    
    enum State: String {
        case pending
        case loading
        case error
        case success
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
        self.state = state.isEmpty ? self.state: State(rawValue: state) ?? .error
        if self.state == .success { self.progress.completedUnitCount = Int64(100) }
    }
}

