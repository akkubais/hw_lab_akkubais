import SwiftUI

struct BottomBar: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack {
            Button(action: viewModel.goBack) {
                Image(systemName: "chevron.left")
            }
            .disabled(!viewModel.canGoBack)
            .accessibilityLabel("Back")

            Spacer()

            Button(action: viewModel.goForward) {
                Image(systemName: "chevron.right")
            }
            .disabled(!viewModel.canGoForward)
            .accessibilityLabel("Forward")

            Spacer()

            Button(action: viewModel.share) {
                Image(systemName: "square.and.arrow.up")
            }
            .accessibilityLabel("Share")

            Spacer()

            Button(action: viewModel.refresh) {
                Image(systemName: "arrow.clockwise")
            }
            .accessibilityLabel("Reload")

            Spacer()

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
