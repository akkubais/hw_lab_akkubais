import SwiftUI
import SwiftData
import UIKit

struct AppView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var path = [Person]()
    @State private var searchText = ""
    @State private var sortOrder = [SortDescriptor(\Person.name)]
    private let screenshotMode: String?

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        if let flagIndex = arguments.firstIndex(of: "-ScreenshotMode"),
           arguments.indices.contains(flagIndex + 1) {
            screenshotMode = arguments[flagIndex + 1]
        } else {
            screenshotMode = nil
        }

        if screenshotMode == "search" {
            _searchText = State(initialValue: "Maya")
        }

        if screenshotMode == "sortDescending" {
            _sortOrder = State(initialValue: [SortDescriptor(\Person.name, order: .reverse)])
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            PeopleView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("My Contacts")
                .navigationDestination(for: Person.self) { person in
                    EditPersonView(person: person)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort", selection: $sortOrder) {
                                Text("Name (A-Z)")
                                    .tag([SortDescriptor(\Person.name)])
                                Text("Name (Z-A)")
                                    .tag([SortDescriptor(\Person.name, order: .reverse)])
                            }
                        }
                        .accessibilityIdentifier("sortMenu")
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Person", systemImage: "plus", action: addPerson)
                            .accessibilityIdentifier("addPersonButton")
                    }
                }
                .searchable(text: $searchText, prompt: "Search contacts")
                .task {
                    prepareDemoIfRequested()
                }
        }
    }

    private func addPerson() {
        let person = Person(name: "", email: "", details: "")
        modelContext.insert(person)
        path.append(person)
    }

    private func prepareDemoIfRequested() {
        guard ProcessInfo.processInfo.arguments.contains("-SeedDemoContacts") else { return }

        let descriptor = FetchDescriptor<Person>()
        if (try? modelContext.fetchCount(descriptor)) == 0 {
            let contacts = [
                Person(
                    name: "Alex Johnson",
                    email: "alex.johnson@example.com",
                    details: "Study group partner and close friend.",
                    photo: Self.demoPortraitData()
                ),
                Person(name: "Maya Chen", email: "maya.chen@example.com", details: "Project teammate"),
                Person(name: "Noah Williams", email: "noah.w@example.com", details: "Robotics club"),
                Person(name: "Zara Ali", email: "zara.ali@example.com", details: "Family friend")
            ]

            for contact in contacts {
                modelContext.insert(contact)
            }
            try? modelContext.save()
        }

        if screenshotMode == "detail", path.isEmpty {
            var sortedDescriptor = FetchDescriptor<Person>()
            sortedDescriptor.sortBy = [SortDescriptor(\Person.name)]
            if let firstContact = try? modelContext.fetch(sortedDescriptor).first {
                path.append(firstContact)
            }
        }
    }

    private static func demoPortraitData() -> Data? {
        let size = CGSize(width: 640, height: 420)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let colors = [
                UIColor(red: 0.12, green: 0.46, blue: 0.95, alpha: 1).cgColor,
                UIColor(red: 0.48, green: 0.22, blue: 0.92, alpha: 1).cgColor
            ] as CFArray
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors,
                locations: [0, 1]
            )!
            context.cgContext.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )

            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 168, weight: .bold),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraph
            ]
            let initials = NSAttributedString(string: "AJ", attributes: attributes)
            let textHeight: CGFloat = 202
            initials.draw(in: CGRect(x: 0, y: (size.height - textHeight) / 2, width: size.width, height: textHeight))
        }
        return image.jpegData(compressionQuality: 0.9)
    }
}

#Preview {
    AppView()
        .modelContainer(for: Person.self, inMemory: true)
}
