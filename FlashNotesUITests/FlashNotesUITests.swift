import XCTest

final class FlashNotesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppLaunch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Verify app launched successfully
        XCTAssertTrue(app.buttons["New Note"].exists)
    }
    
    func testAddNote() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap the 'New Note' button
        app.buttons["New Note"].tap()
        
        // Verify the add note sheet is presented
        XCTAssertTrue(app.textFields["Title"].exists)
        
        // Enter note information
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("UI Test Note")
        
        app.textViews.element.tap()
        app.textViews.element.typeText("This is a test note created by UI automation")
        
        // Save the note
        app.buttons["Save"].tap()
        
        // Give the app a moment to process and display the new note
        let noteExists = app.staticTexts["UI Test Note"].waitForExistence(timeout: 2)
        XCTAssertTrue(noteExists)
    }
}
