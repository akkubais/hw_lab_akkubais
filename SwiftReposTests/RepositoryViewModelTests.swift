import Testing
import Foundation
@testable import SwiftRepos

@MainActor
struct RepositoryViewModelTests {
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

  @Test func startsEmpty() {
    let viewModel = RepositoryViewModel()
    #expect(viewModel.repos.isEmpty)
    #expect(viewModel.filteredRepos.isEmpty)
    #expect(viewModel.searchText == "")
  }

  @Test func emptySearchReturnsAllRepos() {
    let viewModel = RepositoryViewModel()
    viewModel.repos = sampleRepos()
    #expect(viewModel.filteredRepos.count == 3)
  }

  @Test func searchMatchesSubstring() {
    let viewModel = RepositoryViewModel()
    viewModel.repos = sampleRepos()
    viewModel.searchText = "swift"

    #expect(viewModel.filteredRepos.contains { $0.name == "SwiftLint" })
    #expect(!viewModel.filteredRepos.contains { $0.name == "Alamofire" })
  }

  @Test func searchIsCaseInsensitive() {
    let viewModel = RepositoryViewModel()
    viewModel.repos = sampleRepos()
    viewModel.searchText = "VAPOR"

    #expect(viewModel.filteredRepos.count == 1)
    #expect(viewModel.filteredRepos.first?.name == "Vapor")
  }
}

