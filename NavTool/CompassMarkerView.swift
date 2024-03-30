//
//  CompassMarkerView.swift
//  NavTool
//
//  Created by Cooper Anderson on 12/13/23.
//

import SwiftUI

struct CompasMarkerView: View {
    let marker: Marker
    let compassDegrees: Double
    let mapcompas: Bool
    
    var body: some View {
        if mapcompas {
            VStack {
                // numbers
                Text(marker.degreeText()).fontWeight(.light).font(.subheadline).rotationEffect(Angle(degrees: self.compassDegrees))
                Spacer(minLength: 100)
                // dashes
                Capsule().frame(width: self.capsuleWidth(), height: self.capsuleHeight()).foregroundColor(self.capsuleColor())
                // N,S,E,W
                Text(marker.label).fontWeight(.bold).rotationEffect(Angle(degrees: 180))
                    .padding(.bottom, 20)
            }.rotationEffect(Angle(degrees: Double(marker.degrees)))
        } else {
            VStack {
                // numbers
                Text(marker.degreeText()).fontWeight(.light).font(.subheadline).rotationEffect(Angle(degrees: self.compassDegrees))
                Spacer(minLength: 120)
                // dashes
                Capsule().frame(width: self.capsuleWidth(), height: self.capsuleHeight()).foregroundColor(self.capsuleColor())
                // N,S,E,W
                Text(marker.label).fontWeight(.bold).rotationEffect(Angle(degrees: 180))
                    .padding(.bottom, 40)
            }.rotationEffect(Angle(degrees: Double(marker.degrees)))
        }
         
        
    }
    
    // Capsule Width if zero
    private func capsuleWidth() -> CGFloat {
        if mapcompas {
            return 2
        }
        return marker.degrees == 180 ? 5 : 3
    }
    // Capsule Height if zero
    private func capsuleHeight() -> CGFloat {
        if mapcompas {
            return 15
        }
        return marker.degrees == 180 ? 25 : 20
    }
    // Capsule color red if zero
    private func capsuleColor() -> Color {
        return marker.degrees == 180 ? .red : .gray
    }
    //angle applied to text
    private func textAngle() -> Angle {
        return Angle(degrees: Double(self.compassDegrees) - Double(self.marker.degrees))
    }
}
