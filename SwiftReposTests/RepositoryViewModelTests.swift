import Testing
import Foundation
@testable import SwiftRepos

@MainActor
struct RepositoryViewModelTests {
  /// Creates predictable local data so search tests do not depend on the network.
  private func sampleRepos() -> [Repository] {
    [
      Repository(
        id: 1,
        name: "Alamofire",
        itemDescription: "Elegant HTTP Networking in Swift",
        htmlURL: "https://github.com/Alamofire/Alamofire",
        stargazersCount: 40_000
      ),
      Repository(
        id: 2,
        name: "SwiftLint",
        itemDescription: "A tool to enforce Swift style",
        htmlURL: "https://github.com/realm/SwiftLint",
        stargazersCount: 18_000
      ),
      Repository(
        id: 3,
        name: "Vapor",
        itemDescription: "A server-side Swift web framework",
        htmlURL: "https://github.com/vapor/vapor",
        stargazersCount: 24_000
      ),
    ]
  }

  /// Verifies that a newly created view model starts with no repositories or search text.
  @Test func startsEmpty() {
    let viewModel = RepositoryViewModel()
    #expect(viewModel.repos.isEmpty)
    #expect(viewModel.filteredRepos.isEmpty)
    #expect(viewModel.searchText == "")
  }

  /// Verifies that an empty search query leaves every repository visible.
  @Test func emptySearchReturnsAllRepos() {
    let viewModel = RepositoryViewModel()
    viewModel.repos = sampleRepos()
    #expect(viewModel.filteredRepos.count == 3)
  }

  /// Verifies that search finds a repository when the query matches part of its name.
  @Test func searchMatchesSubstring() {
    let viewModel = RepositoryViewModel()
    viewModel.repos = sampleRepos()
    viewModel.searchText = "swift"

    #expect(viewModel.filteredRepos.contains { $0.name == "SwiftLint" })
    #expect(!viewModel.filteredRepos.contains { $0.name == "Alamofire" })
  }

  /// Verifies that repository-name matching does not depend on capitalization.
  @Test func searchIsCaseInsensitive() {
    let viewModel = RepositoryViewModel()
    viewModel.repos = sampleRepos()
    viewModel.searchText = "VAPOR"

    #expect(viewModel.filteredRepos.count == 1)
    #expect(viewModel.filteredRepos.first?.name == "Vapor")
  }
}
