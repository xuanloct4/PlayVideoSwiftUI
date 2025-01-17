
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    @Binding var isLoading: Bool
    @Binding var error: Error?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> WKWebView  {
        var wkwebView = WKWebView()
        wkwebView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        wkwebView.load(request)
        return wkwebView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("loading error: \(error)")
            parent.isLoading = false
            parent.error = error
        }
    }
}
