import SwiftUI

/// Presents a repository's name, optional description, and formatted star count.
struct RepositoryRow: View {
  let repo: Repository

  /// Builds the content displayed for one repository in the list.
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(repo.name)
        .font(.headline)

      if let description = repo.itemDescription {
        // GitHub descriptions are optional, so this text appears only when available.
        Text(description)
          .font(.subheadline)
          .foregroundColor(.secondary)
          .lineLimit(2)
      }

      HStack(spacing: 4) {
        // Pair the star icon with a locale-formatted count for quick scanning.
        Image(systemName: "star.fill")
          .font(.caption)
          .foregroundColor(.yellow)
        Text("\(repo.stargazersCount.formatted())")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 4)
  }
}
