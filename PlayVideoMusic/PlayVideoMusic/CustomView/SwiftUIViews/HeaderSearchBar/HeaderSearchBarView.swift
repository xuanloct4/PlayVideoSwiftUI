//
//  HeaderSearchBarView.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 07/12/2022.
//

import SwiftUI

struct HeaderSearchBarView: View {
    @Binding var searchText: String
    @Binding var isEditing: Bool
    @Binding var isSearchSelected: Bool
    
    var body: some View {
        HStack {
            contentSearchView
            if isEditing {
                cancelButton
            }
        }
        .padding(8)
    }
}

struct HeaderSearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderSearchBarView(searchText: .constant(""), isEditing: .constant(false), isSearchSelected: .constant(false))
    }
}

extension HeaderSearchBarView {
    private var cancelButton: some View {
        Button {
            self.isEditing = false
            self.searchText = ""
            UIApplication.shared.endEditing()
        } label: {
            Text("Cancel")
        }
        .transition(.opacity)
        .animation(.easeInOut, value: isEditing)
        .padding(.trailing, 10)
    }
    
    private var contentSearchView: some View {
        HStack {
            Spacer(minLength: 8)
            Image(Constant.AssetsImage.iconSearch)
                .resizable()
                .frame(width: 20, height: 20, alignment: .leading)
            TextField("", text: $searchText)
                .foregroundColor(Colors.colorFFFFFF)
                .modifier(
                    ClearButton(text: $searchText)
                )
                .placeholder(when: searchText.isEmpty) {
                    Text("Search...").foregroundColor(.gray)
                }
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                        self.isSearchSelected = false
                    }
                }
        }
        .frame(height: 40)
        .background(Colors.color292E4B)
        .cornerRadius(24)
    }
}
