//
//  Marker.swift
//  NavTool
//
//  Created by Cooper Anderson on 12/13/23.
//
import SwiftUI
struct Marker: Hashable {
    let degrees: Double
    let label: String
    
    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }
    
    static func markers() -> [Marker] {
        return [
        Marker(degrees: 0, label: "S"),
        Marker(degrees: 15),
        Marker(degrees: 30),
        Marker(degrees: 45),
        Marker(degrees: 60),
        Marker(degrees: 75),
        Marker(degrees: 90, label: "W"),
        Marker(degrees: 105),
        Marker(degrees: 120),
        Marker(degrees: 135),
        Marker(degrees: 150),
        Marker(degrees: 165),
        Marker(degrees: 180, label: "N"),
        Marker(degrees: 195),
        Marker(degrees: 210),
        Marker(degrees: 225),
        Marker(degrees: 240),
        Marker(degrees: 255),
        Marker(degrees: 270, label: "E"),
        Marker(degrees: 285),
        Marker(degrees: 300),
        Marker(degrees: 315),
        Marker(degrees: 330),
        Marker(degrees: 345),
        ]
    }
    func degreeText() -> String {
        return String(format: "%.0f", self.degrees)
    }
}
