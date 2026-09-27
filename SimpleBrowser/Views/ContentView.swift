import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

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
