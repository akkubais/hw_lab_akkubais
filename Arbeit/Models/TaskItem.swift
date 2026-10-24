import Foundation
import FirebaseFirestore

struct TaskItem: Identifiable, Comparable, Codable, Hashable {

  // MARK: Fields
  @DocumentID var id: String?
  var name: String
  var assignedTo: String
  var dueDate: Date
  var dateAdded: Date
  var completed: Bool
  var ownerId: String? = nil

  // MARK: Codable
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case assignedTo
    case dueDate
    case dateAdded
    case completed
    case ownerId
  }

  /// Hashes exactly the fields used by equality, preserving the Hashable contract.
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(assignedTo)
    hasher.combine(dueDate)
  }

  // MARK: Comparable
  /// Compares the task content used by the lab, independently of its document ID and completion.
  static func ==(lhs: TaskItem, rhs: TaskItem) -> Bool {
    return lhs.name == rhs.name && lhs.assignedTo == rhs.assignedTo && lhs.dueDate == rhs.dueDate
  }

  /// Orders tasks alphabetically by name.
  static func <(lhs: TaskItem, rhs: TaskItem) -> Bool {
    return lhs.name < rhs.name
  }
}

// MARK: - Validation
extension TaskItem {
  /// Requires a nonblank task name and assignee before writing to Firestore.
  static func isValid(name: String, assignedTo: String) -> Bool {
    return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !assignedTo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
