//
//  ResponseMessage.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

/*
 Structure of returned message from Javascript file
 */
struct ResponseMessage: Codable {
    let id: String
    var progress: Int?
    var state: String?
    
    init(id: String, progress: Int? = nil, state: String? = nil) {
        self.id = id
        self.progress = progress
        self.state = state
    }
}
