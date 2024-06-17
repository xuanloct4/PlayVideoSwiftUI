
import Foundation
import WebKit
import SwiftUI

struct LoadingWebView: View {
    @State private var isLoading = true
    @State private var error: Error? = nil
    let url: URL?
    
    var body: some View {
        ZStack {
            if let error = error {
                Text(error.localizedDescription)
                    .foregroundColor(.pink)
            } else if let url = url {
                WebView(url: url,
                        isLoading: $isLoading,
                        error: $error)
                .edgesIgnoringSafeArea(.all)
                if isLoading {
                    ProgressView()
                }
            } else {
                Text("Sorry, we could not load this url.")
            }
            
        }
    }
}

struct SheetWebView: View {
    @State private var isSheetPresented = false
    @State private var isLoading = true
    let url = URL(string: "https://www.swiftyplace.com")
    
    var body: some View {
        Button(action: {
            isSheetPresented = true
        }) {
            Text("Open Web Page")
        }
        .sheet(isPresented: $isSheetPresented) {
            VStack(spacing: 0) {
#if os(macOS)
                HStack {
                    Text(url?.absoluteString ?? "")
                    Spacer()
                    Button {
                        isSheetPresented.toggle()
                    } label: {
                        Label("Close", systemImage: "xmark.circle")
                            .labelStyle(.iconOnly)
                    }
                }
                .padding(10)
#endif
                LoadingWebView(url: url)
                    .frame(minWidth: 300, minHeight: 300)
            }
        }
    }
}
