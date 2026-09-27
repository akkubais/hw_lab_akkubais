import Combine
import Foundation

enum WebViewOption {
    case back
    case forward
    case share
    case refresh
    case stop
    case navigate(URL)
}

final class ViewModel: ObservableObject {
    @Published var urlString = ""
    @Published var shouldShowShareSheet = false
    @Published var currentPageURL: URL?
    @Published var canGoBack = false
    @Published var canGoForward = false

    let webViewOptionsPublisher = PassthroughSubject<WebViewOption, Never>()

    func loadEnteredURL() {
        guard let url = Self.normalizedURL(from: urlString) else { return }
        webViewOptionsPublisher.send(.navigate(url))
    }

    func goBack() {
        webViewOptionsPublisher.send(.back)
    }

    func goForward() {
        webViewOptionsPublisher.send(.forward)
    }

    func share() {
        webViewOptionsPublisher.send(.share)
    }

    func refresh() {
        webViewOptionsPublisher.send(.refresh)
    }

    func stop() {
        webViewOptionsPublisher.send(.stop)
    }

    var shareURL: URL? {
        currentPageURL ?? Self.normalizedURL(from: urlString)
    }

    static func normalizedURL(from input: String) -> URL? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let url = URL(string: trimmed), url.scheme != nil {
            return url
        }

        return URL(string: "https://\(trimmed)")
    }
}
