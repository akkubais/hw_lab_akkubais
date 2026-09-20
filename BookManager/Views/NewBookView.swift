import SwiftUI

struct NewBookView: View {
    @EnvironmentObject private var library: Library

    @State private var title = ""
    @State private var author = ""
    @State private var gender = Gender.female
    @State private var displayed = true
    @State private var showSuccess = false

    private var canSubmit: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Book Information") {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.words)
                        .accessibilityIdentifier("title-field")

                    TextField("Author", text: $author)
                        .textInputAutocapitalization(.words)
                        .accessibilityIdentifier("author-field")
                }

                Section("Author") {
                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityIdentifier("gender-picker")
                }

                Section("Options") {
                    Toggle("Display in library", isOn: $displayed)
                        .accessibilityIdentifier("display-toggle")
                }

                Section {
                    Button {
                        addBook()
                    } label: {
                        Label("Add New Book", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!canSubmit)
                    .accessibilityIdentifier("add-book-button")
                } footer: {
                    Text("A title and author are required.")
                }
            }
            .navigationTitle("New Book")
            .alert("Book Added", isPresented: $showSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("The new book was added to your library.")
            }
        }
    }

    private func addBook() {
        library.addBookToLibrary(
            title: title,
            author: author,
            gender: gender.rawValue,
            displayed: displayed
        )

        title = ""
        author = ""
        gender = .female
        displayed = true
        showSuccess = true
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView()
            .environmentObject(Library())
    }
}
