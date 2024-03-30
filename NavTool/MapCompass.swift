//
//  MapCompass.swift
//  NavTool
//
//  Created by Cooper Anderson on 3/28/24.
// Would be cool if you can make the map rotate with the degrees so where you are facing is always perspective North, top of phone, so you dont have to turn the map. Map rotates with the degree of compass.

import SwiftUI
import ArcGIS

struct MapCompass: View {
    @StateObject var compassHeading = CompassHeading()
    @State var TrackBearing = false
    @State var Mapbool = false
    @State var pinbearing: Double = .zero
    @State var degreegive = 5
    var body: some View {
        NavigationStack {
            HStack {
                VStack {
                    Capsule().frame(width: 5, height: 25)
                        ZStack{
                        ForEach(Marker.mapmarkers(), id: \.self) {marker in
                            //CompassViewMaker
                            CompasMarkerView(marker: marker, compassDegrees: 0, mapcompas: true)
                        }
                        VStack {
                            Text(self.compassHeading.degrees.rounded().description).bold().font(.subheadline).rotationEffect(Angle(degrees: self.compassHeading.degrees))
                        }
                    }.frame(width: 50, height: 175).rotationEffect(Angle(degrees: -self.compassHeading.degrees)).statusBar(hidden: true).padding()
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
                }.padding()
                if TrackBearing {
                    VStack{
                        ZStack {
                            Image(systemName: "arrow.up").scaleEffect(CGSize(width: 3.0, height: 3.0)).rotationEffect(Angle(degrees: (pinbearing - compassHeading.degrees))).foregroundColor(CircleColor()).padding()
                    }
                    Text((pinbearing.rounded().description)+"°").bold().font(.subheadline)
                    }.padding()
                    if TrackBearing {
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
                
            }
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
    MapCompass(compassHeading: CompassHeading(), TrackBearing: false, Mapbool: false, pinbearing: .zero, degreegive: 5)
}
