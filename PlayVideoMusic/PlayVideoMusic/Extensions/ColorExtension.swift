//
//  ColorExtension.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 22/11/2022.
//

import Foundation
import SwiftUI

class Colors {
    static let color2DCEEF: Color = Color(hex: "#2DCEEF")!
    static let color99999F: Color = Color(hex: "#99999F")!
    static let color303033: Color = Color(hex: "#303033")!
    static let color161A1A: Color = Color(hex: "#161A1A")!
    static let color070707: Color = Color(hex: "#070707")!
    static let color757575: Color = Color(hex: "#757575")!
    static let colorC20000: Color = Color(hex: "#C20000")!
    static let colorD8D8D8: Color = Color(hex: "#D8D8D8")!
    static let color8B8B8B: Color = Color(hex: "#8B8B8B")!
    static let colorFFFFFF: Color = Color(hex: "#FFFFFF")!
    static let color1A1A1A: Color = Color(hex: "#1A1A1A")!
    static let color2D2D2D: Color = Color(hex: "#2D2D2D")!
    static let color000000: Color = Color(hex: "#000000")!
    static let color181B2C: Color = Color(hex: "#181B2C")!
    static let color292E4B: Color = Color(hex: "#292E4B")!
    static let colorD9519D: Color = Color(hex: "#D9519D")!
    static let color63666E: Color = Color(hex: "#63666E")!
    
}

extension Color {
    init(hexString: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hexString >> 16) & 0xff) / 255,
            green: Double((hexString >> 08) & 0xff) / 255,
            blue: Double((hexString >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    init?(hex: String) {
        var str = hex
        if str.hasPrefix("#") {
            str.removeFirst()
        }
        if str.count == 3 {
            str = String(repeating: str[str.startIndex], count: 2)
            + String(repeating: str[str.index(str.startIndex, offsetBy: 1)], count: 2)
            + String(repeating: str[str.index(str.startIndex, offsetBy: 2)], count: 2)
        } else if !str.count.isMultiple(of: 2) || str.count > 8 {
            return nil
        }
        let scanner = Scanner(string: str)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        if str.count == 2 {
            let gray = Double(Int(color) & 0xFF) / 255
            self.init(.sRGB,
                      red: gray,
                      green: gray,
                      blue: gray,
                      opacity: 1)
        } else if str.count == 4 {
            let gray = Double(Int(color >> 8) & 0x00FF) / 255
            let alpha = Double(Int(color) & 0x00FF) / 255
            self.init(.sRGB,
                      red: gray,
                      green: gray,
                      blue: gray,
                      opacity: alpha)
        } else if str.count == 6 {
            let red = Double(Int(color >> 16) & 0x0000FF) / 255
            let green = Double(Int(color >> 8) & 0x0000FF) / 255
            let blue = Double(Int(color) & 0x0000FF) / 255
            self.init(.sRGB,
                      red: red,
                      green: green,
                      blue: blue,
                      opacity: 1)
        } else if str.count == 8 {
            let red = Double(Int(color >> 24) & 0x000000FF) / 255
            let green = Double(Int(color >> 16) & 0x000000FF) / 255
            let blue = Double(Int(color >> 8) & 0x000000FF) / 255
            let alpha = Double(Int(color) & 0x000000FF) / 255
            self.init(.sRGB,
                      red: red,
                      green: green,
                      blue: blue,
                      opacity: alpha)
        } else {
            return nil
        }
    }

}

extension Color {
    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
}
