import SwiftUI

struct BookRowView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title)
                .font(.headline)
                .foregroundStyle(.primary)

            Text(book.author)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 3)
    }
}
