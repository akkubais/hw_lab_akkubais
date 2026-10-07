import SwiftUI
import UIKit

/// Wraps UIKit's system share sheet so it can be presented from SwiftUI.
struct ShareSheet: UIViewControllerRepresentable {
    /// Describes the completion handler called after a sharing activity finishes.
    typealias Callback = (
        _ activityType: UIActivity.ActivityType?,
        _ completed: Bool,
        _ returnedItems: [Any]?,
        _ error: Error?
    ) -> Void

    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil

    /// Creates and configures the UIKit activity controller with the items to share.
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }

    /// No update is needed because the share items remain fixed while the sheet is visible.
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) { }
}
