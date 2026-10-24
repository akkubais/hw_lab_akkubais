import SwiftUI

struct TasksView: View {
  @Environment(TasksViewModel.self) private var viewModel
  @State private var showingNewTask = false

  var body: some View {
    List {
      if let message = viewModel.errorMessage {
        Text(message).foregroundStyle(.red)
      }
      if viewModel.isLoading {
        ProgressView("Loading tasks…")
      }

      ForEach(viewModel.tasks) { task in
        NavigationLink(value: task) {
          TaskRowView(task: task)
        }
      }
      .onDelete(perform: deleteTask)
    }
    .navigationTitle("Arbeit")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: { showingNewTask = true }) {
          Image(systemName: "plus")
            .accessibilityLabel("Add Task")
        }
      }
    }
    .sheet(isPresented: $showingNewTask) {
      NewTaskView()
        .environment(viewModel)
    }
    .navigationDestination(for: TaskItem.self) { task in
      TaskDetailsView(task: task)
    }
  }

  /// Resolves the selected list rows into tasks and deletes them.
  private func deleteTask(at offsets: IndexSet) {
    let selectedTasks = offsets.map { viewModel.tasks[$0] }
    for task in selectedTasks {
      viewModel.destroy(task)
    }
  }
}
