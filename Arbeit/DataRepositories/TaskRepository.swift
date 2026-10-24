import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

@Observable
class TaskRepository {
  @ObservationIgnored private let path = "tasks"
  @ObservationIgnored private let store = Firestore.firestore()
  @ObservationIgnored private var listener: ListenerRegistration?

  var tasks: [TaskItem] = []
  var errorMessage: String?
  var isLoading = true

  /// Starts the live Firestore subscription when the repository is created.
  init() {
    get()
  }

  /// Releases the subscription so the repository does not leak a listener.
  deinit {
    listener?.remove()
  }

  /// Replaces the subscription and decodes task snapshots delivered on the main queue.
  func get() {
    listener?.remove()
    isLoading = true
    guard let uid = Auth.auth().currentUser?.uid else {
      isLoading = false
      errorMessage = "Please sign in before loading tasks."
      return
    }
    listener = store.collection(path).whereField("ownerId", isEqualTo: uid).addSnapshotListener { [weak self] snapshot, error in
      guard let self else { return }
      self.isLoading = false
      if let error {
        self.errorMessage = error.localizedDescription
        return
      }
      do {
        self.tasks = try snapshot?.documents.map { try $0.data(as: TaskItem.self) }.sorted() ?? []
        self.errorMessage = nil
      } catch {
        self.errorMessage = "Unable to read tasks: \(error.localizedDescription)"
      }
    }
  }

  /// Encodes a new task and reports any server-side write error to the interface.
  func create(_ task: TaskItem) {
    guard let uid = Auth.auth().currentUser?.uid else {
      errorMessage = "Please sign in before creating a task."
      return
    }
    var ownedTask = task
    ownedTask.ownerId = uid
    do {
      _ = try store.collection(path).addDocument(from: ownedTask) { [weak self] error in
        if let error { self?.errorMessage = error.localizedDescription }
      }
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  /// Writes edited fields to the same document without generating a second task.
  func update(_ task: TaskItem) {
    guard let id = task.id else {
      errorMessage = "This task has no document ID."
      return
    }
    do {
      try store.collection(path).document(id).setData(from: task) { [weak self] error in
        if let error { self?.errorMessage = error.localizedDescription }
      }
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  /// Removes the selected Firestore document and exposes any failed deletion.
  func delete(_ task: TaskItem) {
    guard let id = task.id else {
      errorMessage = "This task has no document ID."
      return
    }
    store.collection(path).document(id).delete { [weak self] error in
      if let error { self?.errorMessage = error.localizedDescription }
    }
  }
}
