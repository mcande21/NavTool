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
    
    var body: some View {
        VStack {
            // numbers
            Text(marker.degreeText()).fontWeight(.light).font(.subheadline).rotationEffect(Angle(degrees: self.compassDegrees))
            Spacer(minLength: 120)
            // dashes
            Capsule().frame(width: self.capsuleWidth(), height: self.capsuleHeight()).foregroundColor(self.capsuleColor())
            // N,S,E,W
            Text(marker.label).fontWeight(.bold).rotationEffect(Angle(degrees: 180))
                .padding(.bottom, 40)
        }
        // this will rotate the numbers so always readable
        .rotationEffect(Angle(degrees: marker.degrees))
    }
    // Capsule Width if zero
    private func capsuleWidth() -> CGFloat {
        return marker.degrees == 180 ? 7 : 3
    }
    // Capsule Height if zero
    private func capsuleHeight() -> CGFloat {
        return marker.degrees == 180 ? 45 : 30
    }
    // Capsule color red if zero
    private func capsuleColor() -> Color {
        return marker.degrees == 180 ? .red : .gray
    }
    //angle applied to text
    private func textAngle() -> Angle {
        return Angle(degrees: self.compassDegrees - self.marker.degrees)
    }
}
