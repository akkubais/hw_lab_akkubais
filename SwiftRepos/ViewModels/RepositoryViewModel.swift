import Foundation
import Observation

/// Owns repository data and prepares it for display by SwiftUI views.
@Observable
final class RepositoryViewModel {
  var repos: [Repository] = []
  var searchText: String = ""

  /// Returns every repository when search is empty, or only case-insensitive name matches.
  var filteredRepos: [Repository] {
    guard !searchText.isEmpty else { return repos }
    return repos.filter { repo in
      repo.name.localizedCaseInsensitiveContains(searchText)
    }
  }

  @ObservationIgnored private let parser = Parser()

  /// Requests repositories from the parser and updates the observable list when they arrive.
  func loadRepositories() {
    parser.fetchRepositories { [weak self] repos in
      // Weakly capture the view model so an in-progress request cannot keep it alive.
      self?.repos = repos
    }
  }
}
