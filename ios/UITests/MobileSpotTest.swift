import XCTest

/// Opens the DiceRoller3D mobile project: chat with build card, then the
/// Chorus browser-simulator preview rendering inside the app.
final class MobileSpotTest: XCTestCase {
    private func snap(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testMobileProject() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-hasEntered", "YES"]
        app.launch()
        sleep(4)

        let menu = app.buttons["menuButton"]
        XCTAssertTrue(menu.waitForExistence(timeout: 15))
        menu.tap()
        sleep(3)

        var row = app.buttons["drawer-DiceRoller3D"]
        if !row.waitForExistence(timeout: 20) {
            app.swipeDown()
            sleep(2)
            menu.tap()
            sleep(3)
            row = app.buttons["drawer-DiceRoller3D"]
        }
        XCTAssertTrue(row.waitForExistence(timeout: 20), "DiceRoller3D should be in the drawer")
        row.tap()
        sleep(4)
        snap(app, "m1-chat")

        app.buttons["previewButton"].firstMatch.tap()
        XCTAssertTrue(app.webViews.firstMatch.waitForExistence(timeout: 25), "preview should render")
        sleep(14)
        snap(app, "m2-preview")

        app.buttons["chatBackButton"].tap()
        sleep(2)
    }
}
