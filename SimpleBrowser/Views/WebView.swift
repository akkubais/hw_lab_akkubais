import Combine
import SwiftUI
import WebKit

/// Adapts `WKWebView` for SwiftUI and connects it to the browser view model.
struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: ViewModel

    /// Creates the coordinator that receives commands and web-navigation callbacks.
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    /// Creates and configures the web view used to display websites.
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        context.coordinator.connect(to: webView)
        return webView
    }

    /// SwiftUI state changes are handled through the command publisher, so no direct update is required.
    func updateUIView(_ webView: WKWebView, context: Context) { }

    /// Bridges SwiftUI actions to `WKWebView` and reports navigation changes back to the view model.
    final class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: WebView
        private weak var webView: WKWebView?
        private var webViewOptionsSubscriber: AnyCancellable?

        /// Starts listening for browser commands emitted by the view model.
        init(parent: WebView) {
            self.parent = parent
            super.init()

            webViewOptionsSubscriber = parent.viewModel.webViewOptionsPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] option in
                    self?.handle(option)
                }
        }

        /// Cancels the Combine subscription when the coordinator is released.
        deinit {
            webViewOptionsSubscriber?.cancel()
        }

        /// Stores a weak reference to the web view after SwiftUI creates it.
        func connect(to webView: WKWebView) {
            self.webView = webView
        }

        /// Performs the requested navigation, sharing, reload, or stop command.
        private func handle(_ option: WebViewOption) {
            guard let webView else { return }

            switch option {
            case .back:
                if webView.canGoBack { webView.goBack() }
            case .forward:
                if webView.canGoForward { webView.goForward() }
            case .share:
                parent.viewModel.currentPageURL = webView.url
                parent.viewModel.shouldShowShareSheet = true
            case .refresh:
                webView.reload()
            case .stop:
                webView.stopLoading()
            case .navigate(let url):
                webView.load(URLRequest(url: url))
            }
        }

        /// Updates the address field and history buttons after a page finishes loading.
        func webView(
            _ webView: WKWebView,
            didFinish navigation: WKNavigation!
        ) {
            parent.viewModel.currentPageURL = webView.url
            parent.viewModel.urlString = webView.url?.absoluteString ?? parent.viewModel.urlString
            updateNavigationState(for: webView)
        }

        /// Refreshes history-button availability when a new navigation begins.
        func webView(
            _ webView: WKWebView,
            didStartProvisionalNavigation navigation: WKNavigation!
        ) {
            updateNavigationState(for: webView)
        }

        /// Restores accurate history-button state if a navigation fails.
        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            updateNavigationState(for: webView)
        }

        /// Copies the web view's back/forward availability into observable SwiftUI state.
        private func updateNavigationState(for webView: WKWebView) {
            parent.viewModel.canGoBack = webView.canGoBack
            parent.viewModel.canGoForward = webView.canGoForward
        }
    }
}
