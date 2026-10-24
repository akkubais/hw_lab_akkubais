# Lab 07: Arbeit Task Manager

Platform: Swift / SwiftUI

Repository: https://github.com/akkubais/hw_lab_akkubais

Submission branch: `hw_lab7_Arbeit`

Arbeit stores tasks in Firebase Cloud Firestore. It supports a live task list, task creation, editing the name/assignee/due date, completion, and deletion through the details screen or a swipe gesture. The model, repository, view model, and views are separated into their own folders. Every explicit function and initializer has a comment explaining its purpose.

## Open and run

1. Open `Arbeit.xcodeproj` in Xcode.
2. Allow Swift Package Manager to resolve Firebase Apple SDK 13.1.1 (Core, Firestore, and Auth).
3. Select the Arbeit scheme and an iPhone simulator, then run.
4. Run Product > Test (Command-U) for the five Swift Testing model tests.

The app bundle identifier is `edu.cmu.akkubais.Arbeit`. The Firebase configuration file belongs to this lab's Arbeit project. It is a client configuration, not an administrator credential. Database access is governed by Firestore security rules.

## Required model tests

- Empty task name is rejected.
- Empty assignee is rejected.
- Both fields present is accepted.
- Equality ignores document ID and completion status.
- Tasks sort alphabetically by name.

The equality test uses a fixed date to avoid timing-dependent comparisons. Hashing uses the same fields as equality. Whitespace-only names and assignees are rejected. The repository removes its snapshot listener when it is released and before starting a replacement listener. The New Task tab resets the form and returns to Tasks after saving.

## Restricted database access

This submission uses restricted access rather than the handout's temporary public test rules, as requested. Firebase Authentication assigns an anonymous identity automatically, and every task stores its `ownerId`. Reads query only that owner's tasks. The deployed `firestore.rules` require authentication, enforce ownership for reads/updates/deletes, and prevent changing a task's owner. All other collections are denied by default.

The anonymous account is retained in the app's keychain. A different installation starts with its own empty task list; it can add tasks normally but cannot read the screenshot installation's tasks. Anonymous accounts are intended for this lab; account linking would be needed to recover tasks across devices or after losing the identity.

## Verification and screenshot automation

The five Swift Testing model tests passed on an iPhone 17 Pro simulator running iOS 26.5 with Xcode 27.1 on October 24, 2026. The submission archive includes the original Xcode result bundle and a readable test log.

The separate `ArbeitEvidence` scheme passed its live app workflow with zero failures and saved seven screenshots as Xcode test attachments. It removes its earlier named sample tasks when rerun. It creates the sample tasks “Complete Arbeit lab” and “Review Swift notes,” checks validation, marks a task complete, opens the delete confirmation, and verifies tasks remain after relaunch. Use the `Arbeit` scheme for the five required model tests.

Keep simulator code signing enabled: Firebase Authentication needs the app's keychain access entitlement to save its anonymous identity. `Arbeit/Arbeit.entitlements` declares the app's keychain group.
