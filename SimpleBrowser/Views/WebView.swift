import Combine
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: ViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        context.coordinator.connect(to: webView)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) { }

    final class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: WebView
        private weak var webView: WKWebView?
        private var webViewOptionsSubscriber: AnyCancellable?

        init(parent: WebView) {
            self.parent = parent
            super.init()

            webViewOptionsSubscriber = parent.viewModel.webViewOptionsPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] option in
                    self?.handle(option)
                }
        }

        deinit {
            webViewOptionsSubscriber?.cancel()
        }

        func connect(to webView: WKWebView) {
            self.webView = webView
        }

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

        func webView(
            _ webView: WKWebView,
            didFinish navigation: WKNavigation!
        ) {
            parent.viewModel.currentPageURL = webView.url
            parent.viewModel.urlString = webView.url?.absoluteString ?? parent.viewModel.urlString
            updateNavigationState(for: webView)
        }

        func webView(
            _ webView: WKWebView,
            didStartProvisionalNavigation navigation: WKNavigation!
        ) {
            updateNavigationState(for: webView)
        }

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            updateNavigationState(for: webView)
        }

        private func updateNavigationState(for webView: WKWebView) {
            parent.viewModel.canGoBack = webView.canGoBack
            parent.viewModel.canGoForward = webView.canGoForward
        }
    }
}
