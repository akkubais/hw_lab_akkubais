import SwiftUI
import SwiftData

struct PeopleView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var people: [Person]

    init(searchString: String = "", sortOrder: [SortDescriptor<Person>] = []) {
        _people = Query(
            filter: #Predicate<Person> { person in
                if searchString.isEmpty {
                    true
                } else {
                    person.name.localizedStandardContains(searchString)
                }
            },
            sort: sortOrder
        )
    }

    var body: some View {
        Group {
            if people.isEmpty {
                ContentUnavailableView(
                    "No Contacts",
                    systemImage: "person.crop.circle.badge.plus",
                    description: Text("Tap the + button to add your first contact.")
                )
            } else {
                List {
                    ForEach(people) { person in
                        NavigationLink(value: person) {
                            ContactRow(person: person)
                        }
                        .accessibilityIdentifier("contact-\(person.name)")
                    }
                    .onDelete(perform: deletePeople)
                }
                .listStyle(.insetGrouped)
            }
        }
    }

    private func deletePeople(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(people[offset])
        }
    }
}

private struct ContactRow: View {
    let person: Person

    var body: some View {
        HStack(spacing: 14) {
            avatar

            VStack(alignment: .leading, spacing: 4) {
                Text(person.name.isEmpty ? "New Person" : person.name)
                    .font(.headline)

                if !person.email.isEmpty {
                    Text(person.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 5)
        }
    }

    @ViewBuilder
    private var avatar: some View {
        if let imageData = person.photo, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 46, height: 46)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 46, height: 46)
                .foregroundStyle(.blue.opacity(0.8))
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Person.self, configurations: config)
    container.mainContext.insert(Person(name: "Alex Johnson", email: "alex@example.com", details: "Friend"))
    container.mainContext.insert(Person(name: "Maya Chen", email: "maya@example.com", details: "Teammate"))

    return NavigationStack {
        PeopleView(sortOrder: [SortDescriptor(\Person.name)])
            .navigationTitle("My Contacts")
    }
    .modelContainer(container)
}

