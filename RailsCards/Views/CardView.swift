import SwiftUI

struct CardView: View {
    @State private var viewModel = CardViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Practice Ruby on Rails")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ZStack {
                    NavigationLink {
                        DefinitionView(viewModel: viewModel)
                    } label: {
                        Text(viewModel.flashcard.command)
                            .font(.system(.title3, design: .monospaced))
                            .multilineTextAlignment(.center)
                            .padding(24)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.blue)
                    .accessibilityIdentifier("commandCard")
                    .accessibilityHint("Shows the definition of this Rails command")
                }
                .frame(width: 350, height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                )
                .onAppear {
                    viewModel.drawNewCard()
                }

                Text("Tap the card to reveal its definition")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("RailsCards")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CardView()
}
