//
//  GPSscreen.swift
//  NavTool
//
//  Created by Cooper Anderson on 3/27/24.
//

import Combine
import SwiftUI
import ArcGIS

struct GPSscreen: View {
    
    @StateObject var deviceLocationService = GETGPS.shared

    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    @State private var map = {
        let map = Map(basemapStyle: .arcGISTopographic)

        map.initialViewpoint = Viewpoint(latitude: 0, longitude: 0, scale: 72_000)

            return map
        }()
    var body: some View {
        VStack {
            MapCompass(compassHeading: CompassHeading(), TrackBearing: false, Mapbool: false, pinbearing: .zero, degreegive: 5)
            MapView(map: map)
        }
        .onAppear {
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            deviceLocationService.requestLocationUpdates()
            updateViewPoint()
        }
    }
    func updateViewPoint() {
        map.initialViewpoint = Viewpoint(latitude: coordinates.lat, longitude: coordinates.lon, scale: 72_000)
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
