import XCTest

/// Exercises the model selector menu and the voice record/transcribe cycle.
final class VoiceModelSpotTest: XCTestCase {
    private func snap(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testModelMenuAndMic() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-hasEntered", "YES"]
        app.launch()
        sleep(4)

        let menu = app.buttons["modelMenu"]
        XCTAssertTrue(menu.waitForExistence(timeout: 10), "model menu should exist")
        menu.tap()
        sleep(2)
        snap(app, "v1-model-menu")

        let opus = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Opus'")).firstMatch
        XCTAssertTrue(opus.waitForExistence(timeout: 5), "Opus option should be in the menu")
        opus.tap()
        sleep(2)
        let opusLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Opus 4.8'")).firstMatch
        XCTAssertTrue(opusLabel.waitForExistence(timeout: 5), "composer should show Opus 4.8")
        snap(app, "v2-opus-selected")

        // Voice: start recording (red stop state), then stop and transcribe.
        let mic = app.buttons["voiceButton"].firstMatch
        XCTAssertTrue(mic.waitForExistence(timeout: 5))
        mic.tap()
        sleep(3)
        snap(app, "v3-recording")
        mic.tap()
        sleep(7) // transcribe round trip (silence -> empty text is fine)
        snap(app, "v4-after-transcribe")

        // Leave the model back on Sonnet for Riley.
        menu.tap()
        sleep(2)
        let sonnet = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Sonnet'")).firstMatch
        XCTAssertTrue(sonnet.waitForExistence(timeout: 5))
        sonnet.tap()
        sleep(1)
    }
}
