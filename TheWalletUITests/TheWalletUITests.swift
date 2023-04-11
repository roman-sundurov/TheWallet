//
//  MoneyManagerUITests.swift
//  MoneyManagerUITests
//
//  Created by Roman on 07.01.2021.
//

import XCTest

var app: XCUIApplication!

class TheWalletUITests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UITest"]
        app.launch()
    }

    // swiftlint:disable all
    func testLogIn() throws {

        let elementsQuery = app!.scrollViews.otherElements
        let youremailEmailComTextField = elementsQuery.textFields["youremail@email.com"]
        let uKey = app!/*@START_MENU_TOKEN@*/.keyboards.keys["u"]/*[[".keyboards.keys[\"u\"]",".keys[\"u\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        let moreKey = app!/*@START_MENU_TOKEN@*/.keyboards.keys["more"]/*[[".keyboards",".keys[\"numbers\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[2,0]]@END_MENU_TOKEN@*/
        let keyDot = app!/*@START_MENU_TOKEN@*/.keyboards.keys["."]/*[[".keyboards.keys[\".\"]",".keys[\".\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        let keySign = app!/*@START_MENU_TOKEN@*/.keyboards.keys["@"]/*[[".keyboards.keys[\"@\"]",".keys[\"@\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/

        youremailEmailComTextField.tap()

        uKey.tap()
        uKey.tap()
        uKey.tap()
        uKey.tap()

        moreKey.tap()

        keySign.tap()

        moreKey.tap()
        uKey.tap()
        uKey.tap()

        moreKey.tap()
        keyDot.tap()

        moreKey.tap()
        uKey.tap()
        uKey.tap()

        elementsQuery.secureTextFields["password"].tap()
        uKey.tap()
        uKey.tap()
        uKey.tap()
        uKey.tap()
        uKey.tap()
        uKey.tap()
        app!.toolbars["Toolbar"].buttons["Done"].tap()
        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Sign in"]/*[[".buttons[\"Sign in\"].staticTexts[\"Sign in\"]",".staticTexts[\"Sign in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

    }

    func testCreateOperation() throws {

        try testLogIn()

        sleep(5)

        // app.launch()
        // let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Add Operation"].tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .textField).element.tap()

        let key = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()

        let key2 = app/*@START_MENU_TOKEN@*/.keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key2.tap()
        let key3 = app.keys["0"]
        key3.tap()

        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Select category"]/*[[".cells.staticTexts[\"Select category\"]",".staticTexts[\"Select category\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["ellipsis"]/*[[".cells.buttons[\"ellipsis\"]",".buttons[\"ellipsis\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let newCategoryTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["New category"]/*[[".cells.textFields[\"New category\"]",".textFields[\"New category\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        newCategoryTextField.tap()

        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()

        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()

        tKey.tap()


        let spaceKey = app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        spaceKey.tap()
        
        let cKey = app/*@START_MENU_TOKEN@*/.keys["c"]/*[[".keyboards.keys[\"c\"]",".keys[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cKey.tap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        tKey.tap()
        eKey.tap()
        
        let gKey = app/*@START_MENU_TOKEN@*/.keys["g"]/*[[".keyboards.keys[\"g\"]",".keys[\"g\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        gKey.tap()
        
        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        oKey.tap()
        
        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        
        let yKey = app/*@START_MENU_TOKEN@*/.keys["y"]/*[[".keyboards.keys[\"y\"]",".keys[\"y\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        yKey.tap()

        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".cells.buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 3).tables.children(matching: .cell).element(boundBy: 2).children(matching: .textField).element.tap()

        app.buttons["Save"].tap()

    }

    func testLaunchPerformance() throws {
        // if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
        if #available(iOS 15.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    // swiftlint:enable all
}
