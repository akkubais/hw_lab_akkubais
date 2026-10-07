import SwiftUI

/// Composes the address bar, web content, bottom toolbar, and share sheet.
struct ContentView: View {
    /// Owns the browser state for the lifetime of this screen.
    @StateObject private var viewModel = ViewModel()

    /// Builds the main browser layout and presents sharing when requested.
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(viewModel: viewModel)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)

            Divider()

            WebView(viewModel: viewModel)

            Divider()

            BottomBar(viewModel: viewModel)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.bar)
        }
        .sheet(isPresented: $viewModel.shouldShowShareSheet) {
            // Share the current URL when available; otherwise explain why sharing is unavailable.
            if let url = viewModel.shareURL {
                ShareSheet(activityItems: [url])
            } else {
                ContentUnavailableView(
                    "Nothing to Share",
                    systemImage: "square.and.arrow.up",
                    description: Text("Open a web page first.")
                )
            }
        }
    }
}
