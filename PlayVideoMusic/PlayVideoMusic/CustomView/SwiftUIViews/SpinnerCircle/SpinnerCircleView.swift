//
//  SpinnerCircleView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 11/01/2023.
//

import SwiftUI

struct SpinnerCircleView: View {
    var start: CGFloat
    var end: CGFloat
    var rotation: Angle
    var color: Color
    
    var body: some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .fill(color)
            .rotationEffect(rotation)
    }
}

struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SpinnerView()
        }
    }
}
