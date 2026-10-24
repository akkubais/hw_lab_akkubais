import Foundation
import Observation

@Observable
class TasksViewModel {
  @ObservationIgnored private let repository: TaskRepository

  /// Initializes the stored dependencies or editable form state.
  init(repository: TaskRepository = TaskRepository()) {
    self.repository = repository
  }

  var errorMessage: String? { repository.errorMessage }
  var isLoading: Bool { repository.isLoading }

  var tasks: [TaskItem] {
    repository.tasks
  }

  /// Forwards a new task to the repository, which owns persistence.
  func add(_ task: TaskItem) {
    repository.create(task)
  }

  /// Writes the edited task back to its existing Firestore document.
  func update(_ task: TaskItem) {
    repository.update(task)
  }

  /// Asks the repository to remove the selected task.
  func destroy(_ task: TaskItem) {
    repository.delete(task)
  }
}
