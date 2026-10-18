import Testing
import Foundation
import SwiftData
@testable import SimpleContacts

@MainActor
struct PersonTests {
    private func makeInMemoryContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: Person.self, configurations: config)
    }

    @Test func personInitializesWithDefaults() {
        let person = Person(name: "Alex Johnson", email: "alex@example.com", details: "Friend")
        #expect(person.name == "Alex Johnson")
        #expect(person.email == "alex@example.com")
        #expect(person.details == "Friend")
        #expect(person.photo == nil)
    }

    @Test func insertingPersistsInContext() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        let person = Person(name: "Maya Chen", email: "maya@example.com", details: "Teammate")
        context.insert(person)
        try context.save()

        let all = try context.fetch(FetchDescriptor<Person>())
        #expect(all.count == 1)
        #expect(all.first?.name == "Maya Chen")
    }

    @Test func deleteRemovesFromContext() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        let person = Person(name: "Noah Williams", email: "noah@example.com", details: "")
        context.insert(person)
        try context.save()

        context.delete(person)
        try context.save()

        let all = try context.fetch(FetchDescriptor<Person>())
        #expect(all.isEmpty)
    }

    @Test func sortDescriptorOrdersByName() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        context.insert(Person(name: "Zara Ali", email: "", details: ""))
        context.insert(Person(name: "Alex Johnson", email: "", details: ""))
        context.insert(Person(name: "Maya Chen", email: "", details: ""))
        try context.save()

        var descriptor = FetchDescriptor<Person>()
        descriptor.sortBy = [SortDescriptor(\.name)]
        let sorted = try context.fetch(descriptor)

        #expect(sorted.map(\.name) == ["Alex Johnson", "Maya Chen", "Zara Ali"])
    }

    @Test func searchPredicateMatchesSubstring() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        context.insert(Person(name: "Alex Johnson", email: "", details: ""))
        context.insert(Person(name: "Maya Johnson", email: "", details: ""))
        context.insert(Person(name: "Zara Ali", email: "", details: ""))
        try context.save()

        let needle = "john"
        let descriptor = FetchDescriptor<Person>(
            predicate: #Predicate { $0.name.localizedStandardContains(needle) }
        )
        let matches = try context.fetch(descriptor)

        #expect(matches.count == 2)
        #expect(matches.allSatisfy { $0.name.localizedStandardContains("john") })
    }
}

