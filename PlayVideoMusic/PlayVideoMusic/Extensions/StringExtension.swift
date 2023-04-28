//
//  StringExtension.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 26/04/2023.
//

import Foundation

extension String {
    static let empty: String = ""
    static let dot: String = "."

    func utf8DecodedString() -> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }

    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }

    func encode(_ s: String) -> String {
        let data = s.data(using: .utf8, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
}
