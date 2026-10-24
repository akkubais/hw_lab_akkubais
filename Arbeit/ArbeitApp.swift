import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  /// Configures Firebase before the root view creates its repository.
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ArbeitApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      // Start with AppView, not generic ContentView
      AuthenticatedRootView()
    }
  }
}

/// Waits for a Firebase identity before creating the task repository.
struct AuthenticatedRootView: View {
  @State private var isReady = false
  @State private var errorMessage: String?

  var body: some View {
    Group {
      if isReady {
        AppView()
      } else if let errorMessage {
        ContentUnavailableView {
          Label("Connection unavailable", systemImage: "wifi.exclamationmark")
        } description: {
          Text(errorMessage)
        } actions: {
          Button("Try Again") { Task { await signIn() } }
        }
      } else {
        ProgressView("Connecting securely…")
      }
    }
    .task { await signIn() }
  }

  /// Reuses the saved anonymous identity or creates one without requesting personal details.
  @MainActor private func signIn() async {
    errorMessage = nil
    do {
      if Auth.auth().currentUser == nil {
        _ = try await Auth.auth().signInAnonymously()
      }
      isReady = true
    } catch {
      errorMessage = error.localizedDescription
    }
  }
}
