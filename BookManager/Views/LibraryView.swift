import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var library: Library

    var body: some View {
        NavigationStack {
            List {
                ForEach(library.books) { book in
                    NavigationLink(value: book.id) {
                        BookRowView(book: book)
                    }
                    .accessibilityIdentifier("book-row-\(book.title)")
                }
                .onDelete(perform: library.removeBooks)
            }
            .navigationTitle("My Library")
            .navigationDestination(for: UUID.self) { id in
                if let book = library.books.first(where: { $0.id == id }) {
                    BookDetailView(book: book)
                }
            }
            .toolbar {
                EditButton()
            }
            .overlay {
                if library.books.isEmpty {
                    ContentUnavailableView(
                        "No Books",
                        systemImage: "books.vertical",
                        description: Text("Add a book from the New Book tab.")
                    )
                }
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .environmentObject(Library())
    }
}
