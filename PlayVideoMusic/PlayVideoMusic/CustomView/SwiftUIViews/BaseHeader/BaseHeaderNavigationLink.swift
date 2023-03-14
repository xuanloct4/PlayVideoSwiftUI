//
//  BaseHeaderNavigationLink.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 06/12/2022.
//

import SwiftUI

struct BaseHeaderNavigationLink<Label, Destination>: View where Label: View, Destination: View {
    let destination: Destination
    let label: Label
    
    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            BaseHeaderContainerView {
                destination
            }
            .navigationBarHidden(true)
        } label: {
            label
        }
    }
}

struct BaseHeaderNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        BaseHeaderNavigationView {
            BaseHeaderNavigationLink(destination: {
                Text("Destination")
            }, label: {
                Text("Click Me")
            })
        }
    }
}
