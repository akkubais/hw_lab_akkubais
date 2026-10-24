import XCTest

/// Captures real simulator evidence while exercising the lab's task workflow.
@MainActor
final class ArbeitEvidenceTests: XCTestCase {
  /// Saves a screenshot as a permanent attachment in the Xcode test result.
  private func capture(_ name: String) {
    let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
    attachment.name = name
    attachment.lifetime = .keepAlways
    add(attachment)
  }

  /// Creates two sample tasks, validates input, edits completion, and captures deletion confirmation.
  func testCaptureTaskFlow() throws {
    continueAfterFailure = false
    let app = XCUIApplication(bundleIdentifier: "edu.cmu.akkubais.Arbeit")
    app.launch()
    XCTAssertTrue(app.buttons["Add Task"].waitForExistence(timeout: 120))
    for name in ["Complete Arbeit lab", "Review Swift notes"] {
      while app.staticTexts[name].firstMatch.exists {
        app.staticTexts[name].firstMatch.tap()
        app.buttons["Delete Task"].tap()
        XCTAssertTrue(app.buttons["Delete"].waitForExistence(timeout: 30))
        app.buttons["Delete"].tap()
        XCTAssertTrue(app.buttons["Add Task"].waitForExistence(timeout: 30))
      }
    }
    app.buttons["Add Task"].tap()
    XCTAssertTrue(app.textFields["Task Name"].waitForExistence(timeout: 30))
    app.buttons["Save"].tap()
    XCTAssertTrue(app.alerts["Validation Error"].waitForExistence(timeout: 30))
    capture("04_validation_error")
    app.alerts["Validation Error"].buttons["OK"].tap()
    app.textFields["Task Name"].tap()
    app.textFields["Task Name"].typeText("Complete Arbeit lab")
    app.textFields["Assigned To"].tap()
    app.textFields["Assigned To"].typeText("Abdulaziz")
    capture("02_new_task_form")
    app.buttons["Save"].tap()
    XCTAssertTrue(app.buttons["Add Task"].waitForExistence(timeout: 30))
    app.buttons["Add Task"].tap()
    XCTAssertTrue(app.textFields["Task Name"].waitForExistence(timeout: 30))
    app.textFields["Task Name"].tap()
    app.textFields["Task Name"].typeText("Review Swift notes")
    app.textFields["Assigned To"].tap()
    app.textFields["Assigned To"].typeText("Abdulaziz")
    app.buttons["Save"].tap()
    XCTAssertTrue(app.staticTexts["Review Swift notes"].waitForExistence(timeout: 30))
    capture("01_loaded_task_list")
    app.staticTexts["Complete Arbeit lab"].tap()
    XCTAssertTrue(app.switches["Completed"].waitForExistence(timeout: 30))
    app.switches["Completed"].coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
    XCTAssertEqual(app.switches["Completed"].value as? String, "1")
    capture("03_task_details_completed")
    app.buttons["Save"].tap()
    XCTAssertTrue(app.staticTexts["Complete Arbeit lab"].waitForExistence(timeout: 30))
    capture("05_saved_completion")
    app.staticTexts["Complete Arbeit lab"].tap()
    app.buttons["Delete Task"].tap()
    XCTAssertTrue(app.buttons["Delete"].waitForExistence(timeout: 30))
    capture("06_delete_confirmation")
    app.terminate()
    app.launch()
    XCTAssertTrue(app.staticTexts["Review Swift notes"].waitForExistence(timeout: 120))
    capture("07_persisted_after_relaunch")
  }
}
