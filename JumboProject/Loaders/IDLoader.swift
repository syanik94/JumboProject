//
//  IDLoader.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct IDLoader {
    static func loadIDs() -> [String] {
        var ids: [String] = []
        for _ in 1...8 {
            let id = UUID().uuidString
            ids.append(id)
        }
        return ids
    }
}
