import Foundation

/// Contains the GitHub repository fields displayed by the app.
nonisolated struct Repository: Codable, Identifiable, Hashable, Sendable {
  let id: Int
  let name: String
  let itemDescription: String?
  let htmlURL: String
  let stargazersCount: Int

  /// Maps GitHub's snake-case JSON keys to Swift-style property names.
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case itemDescription = "description"
    case htmlURL = "html_url"
    case stargazersCount = "stargazers_count"
  }
}
