import Foundation

/// Matches the top-level JSON object returned by GitHub's search endpoint.
nonisolated struct Repositories: Codable, Sendable {
  /// The repository results stored in the API's `items` array.
  let items: [Repository]
}
