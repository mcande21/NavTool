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
        VStack {
            Capsule()         .frame(width: 5, height: 50).padding()
            if TrackBearing {
                Text(pinbearing.rounded().description).bold().font(.subheadline)
            }
            // Zstack
            ZStack{
                ForEach(Marker.markers(), id: \.self) {marker in
                    //CompassViewMaker
                    CompasMarkerView(marker: marker, compassDegrees: 0)
                }
                VStack {
                    if TrackBearing {
                        Image(systemName: "arrow.up").scaleEffect(CGSize(width: 3.0, height: 3.0)).rotationEffect(Angle(degrees: pinbearing)).foregroundColor(CircleColor())
                    } else {
                        Text(self.compassHeading.degrees.rounded().description).bold().font(.subheadline).rotationEffect(Angle(degrees: self.compassHeading.degrees))
                    }
                    
                }
            }
            .frame(width: 50, height: 300).rotationEffect(Angle(degrees: -self.compassHeading.degrees)).statusBar(hidden: true).padding()
            
            if !TrackBearing {
                Button("Track Bearing") {
                    pinbearing = self.compassHeading.degrees
                    TrackBearing.toggle()
                }
            } else {
                Button("Stop Track") {
                    TrackBearing.toggle()
                }
            }
            if TrackBearing {
                HStack{
                    Text("Degree Range").padding().font(.subheadline)
                    Picker(selection: $degreegive, label: Text("Degreegive")) {
                        Text("0").tag(0)
                        /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                        /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
                        Text("3").tag(3)
                        Text("4").tag(4)
                        Text("5").tag(5)
                        Text("6").tag(6)
                        Text("7").tag(7)
                        Text("8").tag(8)
                        Text("9").tag(9)
                        Text("10").tag(10)
                        
                    }
                }
            }
            NavigationStack{
                NavigationLink(destination: {GPSscreen()}, label: {Text("Map")})
            }.navigationDestination(for: String.self, destination: {string in GPSscreen()})
        }
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
