//
//  OAuthFunctionalTests.swift
//  OAuth
//
//  Created by user277759 on 1/25/26.
//

import XCTest

final class OAuthFunctionalTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launch()
    }

    private func loginAsAdmin() {
        let username = app.textFields["login.username"]
        let password = app.secureTextFields["login.password"]
        let signIn = app.buttons["login.signin"]

        XCTAssertTrue(username.waitForExistence(timeout: 2)) // (1)
        XCTAssertTrue(password.exists)                       // (2)
        XCTAssertTrue(signIn.exists)                         // (3)

        username.tap()
        username.typeText("admin")

        password.tap()
        password.typeText("admin1")

        signIn.tap()

        XCTAssertTrue(app.staticTexts["user.fullname"].waitForExistence(timeout: 3)) // (4)
        XCTAssertTrue(app.staticTexts["user.username"].exists)                        // (5)
    }

    private func openPayment() {
        XCTAssertTrue(app.buttons["user.paymentLink"].waitForExistence(timeout: 2)) // (6)
        app.buttons["user.paymentLink"].tap()
        XCTAssertTrue(app.navigationBars["Payment"].waitForExistence(timeout: 2))   // (7)
    }


    func test_01_loginScreenElementsExist() {
        XCTAssertTrue(app.textFields["login.username"].waitForExistence(timeout: 2)) // (8)
        XCTAssertTrue(app.secureTextFields["login.password"].exists)                 // (9)
        XCTAssertTrue(app.buttons["login.signin"].exists)                             // (10)
        XCTAssertTrue(app.buttons["login.gotoRegister"].exists)                       // (11)
    }

    func test_02_successfulLoginShowsProfile() {
        loginAsAdmin()

        XCTAssertTrue(app.staticTexts["user.initials"].exists)    // (12)
        XCTAssertTrue(app.staticTexts["user.fullname"].exists)    // (13)
        XCTAssertTrue(app.staticTexts["user.username"].exists)    // (14)
        XCTAssertTrue(app.buttons["user.signout"].exists)         // (15)
        XCTAssertTrue(app.buttons["user.paymentLink"].exists)     // (16)
    }

    func test_03_signOutReturnsToLogin() {
        loginAsAdmin()

        app.buttons["user.signout"].tap()

        XCTAssertTrue(app.textFields["login.username"].waitForExistence(timeout: 2)) // (17)
        XCTAssertTrue(app.buttons["login.signin"].exists)                             // (18)
    }

    func test_04_paymentFormElementsExist() {
        loginAsAdmin()
        openPayment()

        XCTAssertTrue(app.textFields["pay.name"].exists)   // (19)
        XCTAssertTrue(app.textFields["pay.card"].exists)   // (20)
        XCTAssertTrue(app.textFields["pay.expiry"].exists) // (21)
        XCTAssertTrue(app.secureTextFields["pay.cvv"].exists) // (22)
        XCTAssertTrue(app.textFields["pay.amount"].exists) // (23)
        XCTAssertTrue(app.buttons["pay.submit"].exists)    // (24)
    }

    func test_05_paymentValidationShowsAlert() {
        loginAsAdmin()
        openPayment()

        app.buttons["pay.submit"].tap()
        let alert = app.alerts.element

        XCTAssertTrue(alert.waitForExistence(timeout: 2))  // (25)
        XCTAssertTrue(alert.staticTexts.element.label.count > 0) // (26)

        alert.buttons["OK"].tap()
        XCTAssertFalse(alert.exists) // (27)
    }

    func test_06_paymentSuccessScenario() {
        loginAsAdmin()
        openPayment()

        app.textFields["pay.name"].tap()
        app.textFields["pay.name"].typeText("Jan Nowak")

        app.textFields["pay.card"].tap()
        app.textFields["pay.card"].typeText("4242424242424242") // success (nie kończy się na 0)

        app.textFields["pay.expiry"].tap()
        app.textFields["pay.expiry"].typeText("12/27")

        app.secureTextFields["pay.cvv"].tap()
        app.secureTextFields["pay.cvv"].typeText("123")

        app.textFields["pay.amount"].tap()
        app.textFields["pay.amount"].typeText("200")

        app.buttons["pay.submit"].tap()

        let alert = app.alerts.element
        XCTAssertTrue(alert.waitForExistence(timeout: 3)) // (28)
        XCTAssertTrue(alert.label.contains("Success") || alert.staticTexts.element.label.contains("Success")) // (29)

        alert.buttons["OK"].tap()
        XCTAssertFalse(alert.exists) // (30)
    }
}

