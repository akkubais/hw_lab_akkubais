import XCTest

@MainActor
final class FindMyCarUITests: XCTestCase {
    /// Captures an unmodified screenshot of the actual simulator application.
    private func capture(_ name: String, app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    /// Exercises parking, confirmation, map navigation, and persistence after relaunch.
    func testParkingFlow() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.resetAuthorizationStatus(for: .location)
        app.launch()
        let save = app.buttons["saveCarButton"]
        XCTAssertTrue(save.waitForExistence(timeout: 15))
        capture("01-home", app: app)
        save.tap()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allow = springboard.buttons["Allow While Using App"]
        if allow.waitForExistence(timeout: 4) { allow.tap() }
        let saved = app.alerts["Location Saved"]
        XCTAssertTrue(saved.waitForExistence(timeout: 25), app.debugDescription)
        capture("02-location-saved", app: app)
        saved.buttons["OK"].tap()
        capture("03-saved-home", app: app)
        app.buttons["findCarButton"].tap()
        XCTAssertTrue(app.staticTexts["Your Car Location"].waitForExistence(timeout: 10))
        // Allow Apple's map tiles to load before recording visual output.
        Thread.sleep(forTimeInterval: 10)
        capture("04-car-map", app: app)
        app.terminate()
        app.launch()
        XCTAssertTrue(app.staticTexts["Location Saved"].waitForExistence(timeout: 10))
        capture("05-restored-after-relaunch", app: app)
    }

    /// Verifies denied permission gives an error instead of a misleading success alert.
    func testDeniedPermission() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.resetAuthorizationStatus(for: .location)
        app.launch()
        XCTAssertTrue(app.buttons["saveCarButton"].waitForExistence(timeout: 10))
        app.buttons["saveCarButton"].tap()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let deny = springboard.buttons["Don’t Allow"]
        let denyASCII = springboard.buttons["Don't Allow"]
        if deny.waitForExistence(timeout: 5) { deny.tap() }
        else if denyASCII.exists { denyASCII.tap() }
        let error = app.alerts["Location Error"]
        XCTAssertTrue(error.waitForExistence(timeout: 25))
        capture("06-location-error", app: app)
    }
}
