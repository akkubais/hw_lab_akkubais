# RailsCards - Lab 02 (Swift)

Platform: **Swift / SwiftUI**. Andrew ID: **akkubais**.

Lab 2 branch: **hw_lab2_RailsCards**.

## Run

1. Open `RailsCards.xcodeproj` in Xcode (not the Lab 1 TempConverter project).
2. Select the **RailsCards** scheme and an iPhone simulator with iOS 17 or newer. Use a standard-size iPhone such as iPhone 16; the lab specifies 350 x 200 cards.
3. Press **Command-R**.
4. Tap the command card to open its definition. Use the navigation back button to return and draw another random card. Random selection may occasionally draw the same card again, as allowed by the lab.

## Requirements implemented

- `Flashcard` struct with command, definition, and initializer.
- `Deck` class with all 22 command/definition pairs supplied in the Swift handout, a dictionary loop creating flashcards, and `drawRandomCard()`.
- `Models`, `ViewModels`, and `Views` folders; `RailsCardsApp.swift` at the app root.
- `@Observable` `CardViewModel` owning the deck and current flashcard.
- `@State` view-model ownership in `CardView`.
- `NavigationStack` and `NavigationLink`, passing the same view model to `DefinitionView`.
- `.onAppear` on the command card's `ZStack` draws a new card when it appears.
- Both card faces use a 350 x 200 frame and a gray rounded-rectangle outline with a corner radius of 10. Text has internal padding and centered wrapping.
- Modern `#Preview` declarations for both views.
- The five required Swift Testing tests, including `@MainActor` on `CardViewModelTests`.

An additional UI test exercises navigation, checks for a new command after returning, and attaches three simulator screenshots to the Xcode test result.

## Tests and verification

In Xcode, select the **RailsCards** scheme and an iPhone simulator, then press **Command-U**. The scheme includes the five Swift Testing tests and one XCTest UI test.

The same five model/view-model tests can also be run on macOS with `swift test`. `Package.swift` excludes the SwiftUI app/views from that command; use the Xcode project for the actual iOS app.

See `TEST_RESULTS.txt` for the verification performed during preparation, and `SUBMISSION_CHECKLIST.md` for the remaining submission steps.

The existing Lab 1 source files and its README are preserved. Open the RailsCards project for this lab.
