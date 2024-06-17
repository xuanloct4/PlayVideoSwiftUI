
import Foundation
import WebKit
import SwiftUI

struct BrowserView: View {
    
    @StateObject var browserViewModel = BrowserViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    browserViewModel.goBack()
                }) {
                    Image(systemName: "chevron.backward")
                }
                .disabled(!browserViewModel.canGoBack)
                
                Button(action: {
                    browserViewModel.goForward()
                }) {
                    Image(systemName: "chevron.forward")
                }
                .disabled(!browserViewModel.canGoForward)
                
                .padding(.trailing, 5)
                
                TextField("URL", text: $browserViewModel.urlString, onCommit: {
                    browserViewModel.loadURLString()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    browserViewModel.reload()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .padding(.horizontal)
            
            if let url =  URL(string: browserViewModel.urlString) {
                BrowserWebView(url: url,
                               viewModel: browserViewModel)
                .edgesIgnoringSafeArea(.all)
            } else {
                Text("Please, enter a url.")
            }
        }
    }
}

struct BrowserWebView: UIViewRepresentable {
    let url: URL
    @ObservedObject var viewModel: BrowserViewModel
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        viewModel.webView = webView
        webView.load(URLRequest(url: url))
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

class BrowserViewModel: NSObject, ObservableObject {
    weak var webView: WKWebView? {
        didSet {
            webView?.navigationDelegate = self
        }
    }
    
    @Published var urlString = "https://youtube.com"
    @Published var canGoBack = false
    @Published var canGoForward = false
    
    func loadURLString() {
        if let url = URL(string: urlString) {
            webView?.load(URLRequest(url: url))
        }
    }
    
    func goBack() {
        webView?.goBack()
    }
    
    func goForward() {
        webView?.goForward()
    }
    
    func reload() {
        webView?.reload()
    }
    
    private func updateNavigationState() {
        self.canGoBack = webView?.canGoBack ?? false
        self.canGoForward = webView?.canGoForward ?? false
        self.urlString = webView?.url?.absoluteString ?? "https://"
    }
}

extension BrowserViewModel: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
        updateNavigationState()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinishNavigation")
        updateNavigationState()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation")
        updateNavigationState()
    }
}
