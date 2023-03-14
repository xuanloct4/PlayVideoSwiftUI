//
//  BaseNavigationBarView.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 05/12/2022.
//

import SwiftUI

struct BaseNavigationBarView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let title: String
    let isShowBackButton: Bool
    let isShowRightButton: Bool
    let backgroundColorHeader: Color
    
    var body: some View {
        ZStack {
            HStack() {
                if isShowBackButton {
                    backButton
                }
                Spacer()
                if isShowRightButton {
                    backButton
                }
            }
            titleSection
        }
        .padding()
        .background(
            backgroundColorHeader.ignoresSafeArea(edges: .top)
        )
    }
}

struct BaseNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BaseNavigationBarView(title: "Header View",
                                  isShowBackButton: true,
                                  isShowRightButton: false,
                                  backgroundColorHeader: Colors.color161A1A)
            Spacer()
        }
    }
}

extension BaseNavigationBarView {
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(Constant.AssetsImage.iconBackButton)
        }
    }
        
    private var titleSection: some View {
        VStack() {
            Text(title)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}
