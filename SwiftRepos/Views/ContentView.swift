import SwiftUI

/// Displays the searchable repository list and controls navigation to repository pages.
struct ContentView: View {
  // State owns the observable view model for the lifetime of this screen.
  @State private var viewModel = RepositoryViewModel()

  /// Builds the main repository list, search field, and web-view destination.
  var body: some View {
    NavigationStack {
      List(viewModel.filteredRepos) { repo in
        NavigationLink(value: repo) {
          RepositoryRow(repo: repo)
        }
      }
      .navigationTitle("Swift Repos")
      .searchable(text: Bindable(viewModel).searchText, prompt: "Search repos")
      .navigationDestination(for: Repository.self) { repo in
        // Only create the web view when GitHub supplied a valid repository URL.
        if let url = URL(string: repo.htmlURL) {
          WebView(url: url)
            .navigationTitle(repo.name)
            .navigationBarTitleDisplayMode(.inline)
        }
      }
      .onAppear {
        // Load once; returning from a repository page should not repeat the request.
        if viewModel.repos.isEmpty {
          viewModel.loadRepositories()
        }
      }
    }
  }
}
