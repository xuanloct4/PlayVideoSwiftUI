//
//  UIApplicationExtension.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 06/01/2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
