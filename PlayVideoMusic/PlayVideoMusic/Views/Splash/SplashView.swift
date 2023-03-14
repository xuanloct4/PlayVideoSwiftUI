//
//  SplashView.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 22/11/2022.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive: Bool = false
    @State private var size = 0.8
    @State private var opacity: Double = 0.5
    
    var body: some View {
        if isActive {
            MainTabbarView()
        } else {
            ZStack {
                Colors.color181B2C
                    .ignoresSafeArea(.all)
                
                VStack {
                    VStack {
                        Image(Constant.AssetsImage.iconLogo)
                            .frame(width: 113.49, height: 124.99)
                            .scaledToFit()
                        Text("Muzic")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.isActive.toggle()
                    }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
