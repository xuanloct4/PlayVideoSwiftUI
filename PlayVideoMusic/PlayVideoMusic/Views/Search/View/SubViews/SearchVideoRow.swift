//
//  SearchVideoRow.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 30/11/2022.
//

import SwiftUI

struct SearchVideoRow: View {
    let snippet: Snippet
    var body: some View {
        ZStack {
            Colors.color161A1A
            HStack() {
                VideoImageView(snippet: snippet)
                    .frame(width: 120, height: 72)
                    .cornerRadius(8)
                
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Colors.color99999F, lineWidth: 1)
                    )
                VStack(alignment: .leading, spacing: 4) {
                    Text(snippet.title ?? "")
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .foregroundColor(Colors.colorFFFFFF)
                    Text(snippet.channelTitle ?? "")
                        .font(.subheadline)
                        .foregroundColor(Colors.color99999F)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 5, trailing: 4))
            .frame(maxWidth: .infinity)
            .background(Colors.color161A1A)
        }
    }
}

struct SearchVideoRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchVideoRow(snippet: dev.snippet)
            .previewLayout(.sizeThatFits)
    }
}
