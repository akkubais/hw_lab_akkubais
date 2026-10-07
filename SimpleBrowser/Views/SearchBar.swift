import SwiftUI

/// Displays the URL input field and the control used to open an address.
struct SearchBar: View {
    @ObservedObject var viewModel: ViewModel

    /// Builds an address field that can be submitted from the keyboard or Go button.
    var body: some View {
        HStack(spacing: 8) {
            Text("URL:")
                .fontWeight(.semibold)

            TextField("example.com", text: $viewModel.urlString)
                // URL input should not be capitalized or changed by autocorrect.
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.URL)
                .submitLabel(.go)
                .onSubmit(viewModel.loadEnteredURL)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            // Load the entered address when the user taps the arrow button.
            Button(action: viewModel.loadEnteredURL) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
            }
            .accessibilityLabel("Open URL")
        }
    }
}
