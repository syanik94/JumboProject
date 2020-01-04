//
//  IDLoader.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct IDLoader {
    static func loadIDs(count: Int) -> [String] {
        guard count > 0 else { return [] }
        return (1...count).map { _ in UUID().uuidString }
    }
}
