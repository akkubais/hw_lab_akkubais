import SwiftUI
import WebKit

/// Makes UIKit's `WKWebView` available inside the SwiftUI navigation stack.
struct WebView: UIViewRepresentable {
  let url: URL

  /// Creates the underlying web view once when SwiftUI first displays this screen.
  func makeUIView(context: Context) -> WKWebView {
    WKWebView()
  }

  /// Loads a new URL when the represented SwiftUI value changes.
  func updateUIView(_ webView: WKWebView, context: Context) {
    // Avoid reloading the same page during unrelated SwiftUI updates.
    guard webView.url != url else { return }
    webView.load(URLRequest(url: url))
  }
}
