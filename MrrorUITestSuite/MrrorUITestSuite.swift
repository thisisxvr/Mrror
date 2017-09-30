//
//  MrrorUITestSuite.swift
//  MrrorUITestSuite
//
//  Created by Xavier Francis on 1/10/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import XCTest

class MrrorUITestSuite: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testColorButtonsDidTap() {       
        let app = XCUIApplication()
        app.navigationBars["Mrror.CanvasView"].buttons["Options"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        element.children(matching: .button).element(boundBy: 0).tap()
        element.children(matching: .button).element(boundBy: 1).tap()
        element.children(matching: .button).element(boundBy: 2).tap()
        element.children(matching: .button).element(boundBy: 3).tap()
        element.children(matching: .button).element(boundBy: 4).tap()
    }
    
    func testShapeButtonsDidTap() {
        let app = XCUIApplication()
        app.buttons["Brush"].tap()
        app.buttons["Line"].tap()
        app.buttons["Oval"].tap()
        app.buttons["Square"].tap()
        app.buttons["Rectangle"].tap()
        app.buttons["Triangle"].tap()
    }
    
    func testDeleteButtonConfirmationDidShow() {
        
        let app = XCUIApplication()
        let deleteButton = app.navigationBars["Mrror.CanvasView"].buttons["Delete"]
        deleteButton.tap()
        
        let alert = app.alerts["⚠️"]
        alert.buttons["Cancel"].tap()
        deleteButton.tap()
        alert.buttons["Clear"].tap()
        
    }
    
    func testSaveButtonConfirmationDidShow() {
        
        let app = XCUIApplication()
        let shareButton = app.navigationBars["Mrror.CanvasView"].buttons["Share"]
        shareButton.tap()
        
        let alert = app.alerts["💩"]
        alert.buttons["Cancel"].tap()
        shareButton.tap()
        alert.buttons["Save"].tap()
        
    }
    
    func testLoginDidFail() {
        XCUIApplication().navigationBars["Mrror.CanvasView"].buttons["Log In"].tap()
        
        let app = XCUIApplication()
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("test")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        app.buttons["Login"].tap()
        app.alerts["😖\nWrong username"].buttons["OK"].tap()
        
    }
    
    func testRegisterDidSucceed() {
        
        let app = XCUIApplication()
        app.navigationBars["Mrror.CanvasView"].buttons["Log In"].tap()
        app.buttons["Register"].tap()
        
        // Register.
        let usernameTextField = app.textFields["Select a Username"]
        usernameTextField.tap()
        usernameTextField.typeText("test")
        let enterAPasswordSecureTextField = app.secureTextFields["Enter a Password"]
        enterAPasswordSecureTextField.tap()
        enterAPasswordSecureTextField.typeText("Test123!")
        
        let selectOccupationTextField = app.textFields["Select Occupation"]
        selectOccupationTextField.tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: "Tailor")
        app.textFields["Select Gender"].tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: "Female")
        app.textFields["Select Age Group"].tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: "19-29")
        
        app.buttons["Register"].tap()
        app.alerts["😃\nAccount created"].buttons["OK"].tap()
        
        // Login.
        app.textFields["Username"].typeText("test")
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("Test123!")

        
        let element = app.otherElements.containing(.navigationBar, identifier:"Mrror.CanvasView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
        element.tap()
        element.tap()
        
    }

}
