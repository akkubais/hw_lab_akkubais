import SwiftUI
import SwiftData
import PhotosUI

struct EditPersonView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var person: Person
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        Form {
            Section("Photo") {
                if let imageData = person.photo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .accessibilityLabel("Contact photo")
                } else {
                    HStack {
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(.secondary.opacity(0.55))
                            .accessibilityLabel("No contact photo")
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "photo.on.rectangle")
                }
                .accessibilityIdentifier("photoPicker")
            }

            Section("Information") {
                TextField("Name", text: $person.name)
                    .textContentType(.name)
                    .accessibilityIdentifier("nameField")
                TextField("Email", text: $person.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("emailField")
            }

            Section("Details") {
                TextField("Details", text: $person.details, axis: .vertical)
                    .lineLimit(3...6)
                    .accessibilityIdentifier("detailsField")
            }
        }
        .navigationTitle("Edit Person")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedItem) { _, _ in
            loadPhoto()
        }
        .onDisappear {
            try? modelContext.save()
        }
    }

    private func loadPhoto() {
        Task { @MainActor in
            do {
                person.photo = try await selectedItem?.loadTransferable(type: Data.self)
            } catch {
                selectedItem = nil
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Person.self, configurations: config)
    let person = Person(name: "Alex Johnson", email: "alex@example.com", details: "Study group partner")
    container.mainContext.insert(person)

    return NavigationStack {
        EditPersonView(person: person)
    }
    .modelContainer(container)
}
