import Foundation
import Alamofire

/// Handles communication with the GitHub repository search API.
final class Parser {
  // The query requests Swift repositories ordered from most to least starred.
  private let url = "https://api.github.com/search/repositories?q=language:swift&sort=stars&order=desc"

  /// Fetches and decodes repositories, returning an empty array if the request fails.
  /// - Parameter completion: Called with the repositories returned by GitHub.
  func fetchRepositories(completion: @escaping ([Repository]) -> Void) {
    AF.request(url)
      // Reject non-success HTTP status codes before attempting to decode the body.
      .validate()
      .responseDecodable(of: Repositories.self) { response in
        switch response.result {
        case .success(let container):
          // Unwrap the API's top-level container before passing data to the view model.
          completion(container.items)
        case .failure(let error):
          print("Error fetching repositories: \(error.localizedDescription)")
          // Returning an empty list keeps the UI in a safe state after an error.
          completion([])
        }
      }
  }
}
