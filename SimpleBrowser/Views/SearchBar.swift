import SwiftUI

struct SearchBar: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack(spacing: 8) {
            Text("URL:")
                .fontWeight(.semibold)

            TextField("example.com", text: $viewModel.urlString)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.URL)
                .submitLabel(.go)
                .onSubmit(viewModel.loadEnteredURL)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Button(action: viewModel.loadEnteredURL) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
            }
            .accessibilityLabel("Open URL")
        }
    }
}
