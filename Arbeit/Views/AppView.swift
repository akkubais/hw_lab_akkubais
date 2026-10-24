import SwiftUI

struct AppView: View {
  @State private var tasksViewModel = TasksViewModel()

  @State private var selectedTab = 0

  var body: some View {
    TabView(selection: $selectedTab) {
      NavigationStack {
        TasksView()
      }
      .tabItem {
        Image(systemName: "checkmark.rectangle.stack.fill")
        Text("Tasks")
      }
      .tag(0)

      NavigationStack {
        NewTaskView(onSaved: { selectedTab = 0 })
      }
      .tabItem {
        Image(systemName: "plus.app.fill")
        Text("New Task")
      }
      .tag(1)
    }
    .environment(tasksViewModel)
  }
}
