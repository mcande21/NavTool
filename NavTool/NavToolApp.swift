//
//  NavToolApp.swift
//  NavTool
//
//  Created by Cooper Anderson on 12/13/23.
//

import SwiftUI
import ArcGIS

@main
struct NavToolApp: App {
    init() {
            ArcGISEnvironment.apiKey = APIKey("AAPK6b45c1f8eac1405aa103b0614784c431DJuKvLWEoirfHPtP51L1O21R_KSJF17NB-bs4V-pEBmRLKTx0V96mEhsZipU1PkZ")
        }
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView(yourName: "Cooper")
                .ignoresSafeArea()
        }
    }
}
