import Combine
import Foundation

/// Commands that the SwiftUI controls can send to the underlying web view.
enum WebViewOption {
    case back
    case forward
    case share
    case refresh
    case stop
    case navigate(URL)
}

/// Stores the browser's UI state and translates user actions into web-view commands.
final class ViewModel: ObservableObject {
    /// Text currently shown in the address field.
    @Published var urlString = ""
    /// Controls whether the system share sheet is presented.
    @Published var shouldShowShareSheet = false
    /// The URL of the page most recently displayed by the web view.
    @Published var currentPageURL: URL?
    /// Indicates whether a previous page is available in browser history.
    @Published var canGoBack = false
    /// Indicates whether a later page is available in browser history.
    @Published var canGoForward = false

    /// Publishes browser commands for `WebView.Coordinator` to perform on `WKWebView`.
    let webViewOptionsPublisher = PassthroughSubject<WebViewOption, Never>()

    /// Validates the address-field text and asks the web view to load the resulting URL.
    func loadEnteredURL() {
        guard let url = Self.normalizedURL(from: urlString) else { return }
        webViewOptionsPublisher.send(.navigate(url))
    }

    /// Requests navigation to the previous page in browser history.
    func goBack() {
        webViewOptionsPublisher.send(.back)
    }

    /// Requests navigation to the next page in browser history.
    func goForward() {
        webViewOptionsPublisher.send(.forward)
    }

    /// Requests presentation of the system share sheet for the current page.
    func share() {
        webViewOptionsPublisher.send(.share)
    }

    /// Requests that the current page be loaded again.
    func refresh() {
        webViewOptionsPublisher.send(.refresh)
    }

    /// Requests cancellation of the web view's current loading operation.
    func stop() {
        webViewOptionsPublisher.send(.stop)
    }

    /// Returns the loaded page URL, or falls back to a valid URL from the address field.
    var shareURL: URL? {
        currentPageURL ?? Self.normalizedURL(from: urlString)
    }

    /// Converts user input into a URL, adding an HTTPS scheme when one was not supplied.
    static func normalizedURL(from input: String) -> URL? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let url = URL(string: trimmed), url.scheme != nil {
            return url
        }

        return URL(string: "https://\(trimmed)")
    }
}
