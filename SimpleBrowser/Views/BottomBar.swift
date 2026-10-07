import SwiftUI

/// Displays the browser navigation and page-action buttons.
struct BottomBar: View {
    @ObservedObject var viewModel: ViewModel

    /// Builds the toolbar and disables history buttons when their actions are unavailable.
    var body: some View {
        HStack {
            // Move to the previous page in the web view's history.
            Button(action: viewModel.goBack) {
                Image(systemName: "chevron.left")
            }
            .disabled(!viewModel.canGoBack)
            .accessibilityLabel("Back")

            Spacer()

            // Move to the next page in the web view's history.
            Button(action: viewModel.goForward) {
                Image(systemName: "chevron.right")
            }
            .disabled(!viewModel.canGoForward)
            .accessibilityLabel("Forward")

            Spacer()

            // Open the iOS share sheet for the current page.
            Button(action: viewModel.share) {
                Image(systemName: "square.and.arrow.up")
            }
            .accessibilityLabel("Share")

            Spacer()

            // Reload the page currently displayed by the web view.
            Button(action: viewModel.refresh) {
                Image(systemName: "arrow.clockwise")
            }
            .accessibilityLabel("Reload")

            Spacer()

            // Stop an in-progress page load.
            Button(action: viewModel.stop) {
                Image(systemName: "xmark")
            }
            .accessibilityLabel("Stop")
        }
        .font(.title3)
        .buttonStyle(.plain)
        .foregroundStyle(Color.accentColor)
    }
}
