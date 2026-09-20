import XCTest
@testable import BookManager

final class BookManagerTests: XCTestCase {
    func testSeedDataIsSorted() {
        let library = Library()

        XCTAssertEqual(library.books, library.books.sorted())
        XCTAssertEqual(library.books.count, 78)
    }

    func testGenderFiltersCoverLibrary() {
        let library = Library()

        let total = library.getFemaleAuthoredBooks().count + library.getMaleAuthoredBooks().count
        XCTAssertEqual(total, library.books.count)
    }

    func testAddingBookSortsAndFiltersIt() {
        let library = Library(books: [])

        library.addBookToLibrary(
            title: "  Diary of a Young Girl  ",
            author: "  Anne Frank  ",
            gender: Gender.female.rawValue,
            displayed: true
        )

        XCTAssertEqual(library.books.first?.title, "Diary of a Young Girl")
        XCTAssertEqual(library.getBooksFor("Anne Frank").count, 1)
        XCTAssertEqual(library.getFemaleAuthoredBooks().count, 1)
    }

    func testRemovingBookUsesOffsets() {
        let library = Library(books: [
            Book(title: "A", author: "One", gender: "Female"),
            Book(title: "B", author: "Two", gender: "Male")
        ])

        library.removeBooks(at: IndexSet(integer: 0))

        XCTAssertEqual(library.books.map(\.title), ["B"])
    }
}
