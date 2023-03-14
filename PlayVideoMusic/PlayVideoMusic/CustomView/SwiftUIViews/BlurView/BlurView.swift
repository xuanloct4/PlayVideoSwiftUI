//
//  BlurView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 21/12/2022.
//

import Foundation
import SwiftUI

struct BlurView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        view.backgroundColor = .black
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
