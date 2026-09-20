import SwiftUI

struct BookDetailView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Label("Title", systemImage: "book.closed.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.indigo)

            Text(book.title)
                .font(.largeTitle.bold())
                .accessibilityIdentifier("detail-title")

            Divider()

            DetailItem(label: "Author", value: book.author, icon: "person.fill")
            DetailItem(label: "Author Gender", value: book.gender, icon: "person.2.fill")
            DetailItem(
                label: "Displayed",
                value: book.displayed ? "Yes" : "No",
                icon: book.displayed ? "eye.fill" : "eye.slash.fill"
            )

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct DetailItem: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(.indigo)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.title3.weight(.medium))
            }
        }
    }
}
