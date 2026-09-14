import XCTest

final class RailsCardsUITests: XCTestCase {
    @MainActor
    func testRevealDefinitionAndDrawOnReturn() throws {
        let app = XCUIApplication()
        app.launch()
        let card = app.buttons["commandCard"]
        XCTAssertTrue(card.waitForExistence(timeout: 10))
        let original = card.label
        attachScreenshot("01-command")

        card.tap()
        let definition = app.staticTexts["definitionText"]
        XCTAssertTrue(definition.waitForExistence(timeout: 5))
        XCTAssertFalse(definition.label.isEmpty)
        attachScreenshot("02-definition")

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        for _ in 0..<50 {
            if card.label != original { break }
            card.tap()
            XCTAssertTrue(definition.waitForExistence(timeout: 5))
            app.navigationBars.buttons.element(boundBy: 0).tap()
            XCTAssertTrue(card.waitForExistence(timeout: 5))
        }
        XCTAssertNotEqual(card.label, original)
        attachScreenshot("03-new-command")
    }

    @MainActor
    private func attachScreenshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
