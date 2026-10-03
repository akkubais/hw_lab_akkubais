# SwiftRepos

SwiftRepos is an iOS 17 SwiftUI app that loads the most-starred Swift repositories from GitHub. It uses Alamofire and `Codable` for networking, an `@Observable` view model for state, a system search field for filtering, and an in-app `WKWebView` for repository pages.

## Run the app

1. Open `SwiftRepos.xcodeproj` in Xcode.
2. Wait for Xcode to resolve the Alamofire package.
3. Select an iPhone simulator running iOS 17 or later.
4. Press Run (`Command-R`).

The app loads repositories from the GitHub Search API. Type in the search field to filter by repository name, then tap a row to open its GitHub page in the app.

## Tests

Press `Command-U` in Xcode to run the Swift Testing suite. The tests cover the initial empty state, an empty search, substring matching, and case-insensitive matching.

## Submission

- Platform: Swift
- Branch: `hw_lab5_SwiftRepos`
- Repository: `https://github.com/akkubais/hw_lab_akkubais`

