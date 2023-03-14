//
//  ClearButton.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 07/12/2022.
//

import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        HStack() {
            content
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                    UIApplication.shared.endEditing()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
                .padding(.trailing, 8)
            }
        }
    }
}
