//
//  SearchAutoCompleteRow.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 12/12/2022.
//

import SwiftUI

struct SearchAutoCompleteRow: View {
    let content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(content)
                .foregroundColor(.white)
                .padding(8)
            Divider()
                .frame(width: UIScreen.main.bounds.width - 32)
        }
    }
}

struct SearchAutoCompleteRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchAutoCompleteRow(content: "Duy Anh ĐZ")
            .previewLayout(.sizeThatFits)
    }
}
