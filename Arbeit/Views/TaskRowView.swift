import SwiftUI

struct TaskRowView: View {
  let task: TaskItem

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(task.name)
          .font(.headline)
          .strikethrough(task.completed)

        Text("Assigned to: \(task.assignedTo)")
          .font(.subheadline)
          .foregroundColor(.secondary)

        Text("Due: \(task.dueDate, style: .date)")
          .font(.caption)
          .foregroundColor(.secondary)
      }

      Spacer()

      if task.completed {
        Image(systemName: "checkmark.circle.fill")
          .foregroundColor(.green)
      }
    }
    .padding(.vertical, 4)
  }
}
