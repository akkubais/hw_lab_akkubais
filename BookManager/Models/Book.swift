import Foundation

struct Book: Identifiable, Comparable {
    let id: UUID
    let title: String
    let author: String
    let gender: String
    let displayed: Bool

    init(
        id: UUID = UUID(),
        title: String,
        author: String,
        gender: String,
        displayed: Bool = true
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.gender = gender
        self.displayed = displayed
    }

    static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.title == rhs.title && lhs.author == rhs.author
    }

    static func < (lhs: Book, rhs: Book) -> Bool {
        lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
    }
}
