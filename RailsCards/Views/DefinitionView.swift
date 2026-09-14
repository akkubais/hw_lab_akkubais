import SwiftUI

struct DefinitionView: View {
    let viewModel: CardViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("What the command does")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ZStack {
                Text(viewModel.flashcard.definition)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(24)
                    .accessibilityIdentifier("definitionText")
            }
            .frame(width: 350, height: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray)
            )

            Text("Go back to draw another random card")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Definition")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DefinitionView(viewModel: CardViewModel())
}
