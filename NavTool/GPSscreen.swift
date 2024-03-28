//
//  GPSscreen.swift
//  NavTool
//
//  Created by Cooper Anderson on 3/27/24.
//

import Combine
import SwiftUI

struct GPSscreen: View {
    
    @StateObject var deviceLocationService = GETGPS.shared

    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    var body: some View {
        VStack {
            MapCompass(compassHeading: CompassHeading(), TrackBearing: false, Map: false, pinbearing: .zero, degreegive: 5)
            Text("You are at: ")
            Text("Latitude: \(coordinates.lat)")
                .font(.subheadline)
            Text("Longitude: \(coordinates.lon)")
                .font(.subheadline)
        }
        .onAppear {
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            deviceLocationService.requestLocationUpdates()
        }
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }

    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Handle access denied event, possibly with an alert.")
            }
            .store(in: &tokens)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
