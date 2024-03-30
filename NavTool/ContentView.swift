//
//  ContentView.swift
//  NavTool
//
//  Created by Cooper Anderson on 12/13/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var compassHeading = CompassHeading()
    @State var TrackBearing = false
    @State var Map = false
    @State var pinbearing: Double = .zero
    @State var degreegive = 5
    var body: some View {
        NavigationStack {
            VStack {
                Capsule()         .frame(width: 5, height: 50).padding()
                // Zstack
                ZStack{
                    ForEach(Marker.markers(), id: \.self) {marker in
                        //CompassViewMaker
                        CompasMarkerView(marker: marker, compassDegrees: 0, mapcompas: false)
                        }
                    Text(self.compassHeading.degrees.rounded().description).bold().font(.subheadline).rotationEffect(Angle(degrees: self.compassHeading.degrees))
                    }.frame(width: 50, height: 300).rotationEffect(Angle(degrees: -self.compassHeading.degrees)).statusBar(hidden: true).padding()
            }
            
            NavigationLink(destination: {GPSscreen()}, label: {Text("Map")})
        }.navigationDestination(for: String.self, destination: {string in GPSscreen()})
    }
    private func CircleColor() -> Color {
        let heading = self.compassHeading.degrees
        if heading > pinbearing - Double(degreegive) && heading < pinbearing + Double(degreegive) {
            return .green
        } else {
            return .red
            
            
        }
    }
}
#Preview {
    ContentView(compassHeading: CompassHeading(), TrackBearing: false, Map: false, pinbearing: .zero, degreegive: 5)
}
