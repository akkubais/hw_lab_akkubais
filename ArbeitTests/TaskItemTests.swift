import Testing
import Foundation
@testable import Arbeit

@MainActor
struct TaskItemTests {

  private static let fixedDate = Date(timeIntervalSince1970: 1_700_000_000)

  /// Creates deterministic model data so equality tests share exactly the same dates.
  private func sample(name: String = "Write lab",
                      assignedTo: String = "Prof H",
                      dueDate: Date = TaskItemTests.fixedDate) -> TaskItem {
    TaskItem(
      name: name,
      assignedTo: assignedTo,
      dueDate: dueDate,
      dateAdded: TaskItemTests.fixedDate,
      completed: false
    )
  }

  /// Checks that an empty name cannot be saved.
  @Test func validationRejectsEmptyName() {
    #expect(TaskItem.isValid(name: "", assignedTo: "someone") == false)
  }

  /// Checks that an empty assignee cannot be saved.
  @Test func validationRejectsEmptyAssignee() {
    #expect(TaskItem.isValid(name: "something", assignedTo: "") == false)
  }

  /// Checks that a task with a name and assignee is valid.
  @Test func validationAcceptsBothPresent() {
    #expect(TaskItem.isValid(name: "something", assignedTo: "someone") == true)
  }

  /// Checks that equality follows the content fields specified in the handout.
  @Test func equalityIgnoresIdAndCompletion() {
    var a = sample()
    var b = sample()
    a.id = "abc"
    b.id = "xyz"
    b.completed = true  // completed is not part of `==`
    #expect(a == b)     // same name, assignedTo, dueDate
  }

  /// Checks that Comparable returns tasks in alphabetical order.
  @Test func sortsByName() {
    let apple = sample(name: "Apple")
    let banana = sample(name: "Banana")
    let cherry = sample(name: "Cherry")
    let sorted = [cherry, apple, banana].sorted()
    #expect(sorted.map(\.name) == ["Apple", "Banana", "Cherry"])
  }
}
