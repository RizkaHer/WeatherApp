//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Guest-BCA-GSIT-iMac 1 on 30/10/18.
//  Copyright © 2018 Guest-BCA-GSIT-iMac 1. All rights reserved.
//

import XCTest

@testable import WeatherApp

class WeatherAppUITests: XCTestCase {
    var app : XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchBarTypeNCancel(){
        
        let app = XCUIApplication()
        let cityLocationSearchField = app.searchFields["City Location"]
        XCTAssertTrue(cityLocationSearchField.exists)
        XCTAssertTrue(app.staticTexts["JAKARTA"].exists)
        
        cityLocationSearchField.tap()
        let textType = "Kudus, Jawa Tengah"
        cityLocationSearchField.typeText("\(textType)")
        
        let textTyped = cityLocationSearchField.value as! String
        XCTAssertEqual(textTyped, textType)
        
        app.buttons["Cancel"].tap()
        cityLocationSearchField.tap()
        let cancelText = cityLocationSearchField.value as! String
        
        XCTAssertEqual(cancelText, "City Location")
        XCTAssertTrue(app.staticTexts["JAKARTA"].exists)
    }
    
    func testSearchBarSearched(){
        
        let app = XCUIApplication()
        let cityLocationSearchField = app.searchFields["City Location"]
        cityLocationSearchField.tap()
        
        let textType = "Kudus, Jawa Tengah"
        cityLocationSearchField.typeText("\(textType)")
        
        cityLocationSearchField.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: app.staticTexts["Kudus"], handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        
        XCTAssertTrue(app.staticTexts["Kudus"].exists)
        XCTAssertTrue(app.staticTexts["degreeLabel"].exists)
        XCTAssertTrue(app.staticTexts["weatherLabel"].exists)
        
        
    }
    
    func testSegmentedBar (){
        
        let app = XCUIApplication()
        let fahrenheit = app/*@START_MENU_TOKEN@*/.buttons["FAHRENHEIT"]/*[[".segmentedControls.buttons[\"FAHRENHEIT\"]",".buttons[\"FAHRENHEIT\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let celcius = app/*@START_MENU_TOKEN@*/.buttons["CELCIUS"]/*[[".segmentedControls.buttons[\"CELCIUS\"]",".buttons[\"CELCIUS\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let degreeLabel = app.staticTexts["degreeLabel"]
        
        XCTAssertTrue(fahrenheit.exists)
        XCTAssertTrue(celcius.exists)
        XCTAssertTrue(degreeLabel.exists)
        
        var fahrenheitValue = (degreeLabel.label as NSString).floatValue
        celcius.tap()
        
        var celciusValue = (fahrenheitValue-32)/9*5
        var celciusResult = NSString(format:"%.2f",celciusValue)
        
        XCTAssertEqual(degreeLabel.label, celciusResult as String)
        
        celciusValue = (degreeLabel.label as NSString).floatValue
        
        fahrenheit.tap()
        fahrenheitValue = (celciusValue/5*9)+32
        var fahrenheitResult = NSString(format:"%.2f",fahrenheitValue)
        
        XCTAssertEqual(degreeLabel.label, fahrenheitResult as String)
//        if(fahrenheit.isSelected){
//            XCTAssertTrue(fahrenheitLbl.exists)
//            XCTAssertFalse(celciusLbl.exists)
//            celcius.tap()
//            XCTAssertTrue(celciusLbl.exists)
//            XCTAssertFalse(fahrenheitLbl.exists)
//        } else if celciusLbl.isSelected{
//            XCTAssertTrue(celciusLbl.exists)
//            XCTAssertFalse(fahrenheitLbl.exists)
//
//            fahrenheit.tap()
//            XCTAssertTrue(fahrenheitLbl.exists)
//            XCTAssertFalse(celciusLbl.exists)
//        }
        
    }

    
}
