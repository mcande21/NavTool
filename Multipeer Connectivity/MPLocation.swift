//
//  MPLocation.swift
//  NavTool
//
//  Created by Cooper Anderson on 3/31/24.
//

import Foundation

struct MPLocation: Codable {
    enum Action: Int, Codable {
        case start, lat, lon, end
    }
    let action: Action
    let playrName: String?
    let Index: Double?
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
