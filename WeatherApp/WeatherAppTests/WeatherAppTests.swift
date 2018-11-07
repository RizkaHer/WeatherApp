//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Guest-BCA-GSIT-iMac 1 on 30/10/18.
//  Copyright © 2018 Guest-BCA-GSIT-iMac 1. All rights reserved.
//


import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    var sessionUnderTest : URLSession!
    var controllerUnderTest: ViewController!
    
   override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        controllerUnderTest = ViewController()

    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testCallWeather() {
        let url = URL(string: "https://api.darksky.net/forecast/ae0689290d9d2c94ad502883d593a295/37.8267,-122.4233?exclude=minutely,hourly,flags")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        //var responseError: Error?
        let dataTask = sessionUnderTest.dataTask(with: url!){ data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            promise.fulfill()
            
        }
        dataTask.resume()
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testCallLocation(){
        let url = URL(string: "https://api.opencagedata.com/geocode/v1/json?q=Kudus%2C+Jawa+Tengah&key=481025d551544a41bbf11e717bfb7fce&pretty=1")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        //var responseError: Error?
        let dataTask = sessionUnderTest.dataTask(with: url!){ data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            promise.fulfill()
            
        }
        dataTask.resume()
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testUrlFormatter() {
        let test2 = controllerUnderTest.change(intoUrlFormat: "Kudus, Jawa Tengah")
        XCTAssertEqual(test2, "Kudus%2C+Jawa+Tengah" )
    }
    
    func testLocation(){
        let url = URL(string: "https://api.opencagedata.com/geocode/v1/json?q=Kudus%2C+Jawa+Tengah&key=481025d551544a41bbf11e717bfb7fce&pretty=1")!
        let promise = expectation(description: "Data complete")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if error == nil {
                self.controllerUnderTest.processJsonLocation(data)
                XCTAssertEqual(self.controllerUnderTest.geography, "-6.8170915,110.838189")
                print(self.controllerUnderTest.geography)
                
                promise.fulfill()
            }
            else{
                print(error?.localizedDescription as Any)
            }
        }
        dataTask.resume()
      //  let geo = self.controllerUnderTest.geography
        
        waitForExpectations(timeout: 15, handler:nil)
        
        }
    
    func testWeather(){
        let url = URL(string: "https://api.darksky.net/forecast/ae0689290d9d2c94ad502883d593a295/-6.175110,106.865036?,exclude=minutely,hourly,flags")!
        let promise = expectation(description: "Data complete")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if error == nil {
                self.controllerUnderTest.processJsonWeather(data)
                XCTAssertEqual(self.controllerUnderTest.temp,82.25)
                XCTAssertEqual(self.controllerUnderTest.condition,"Light Rain")
                print(self.controllerUnderTest.temp)
                print(self.controllerUnderTest.condition)
                
                promise.fulfill()
            }
            else{
                print(error?.localizedDescription as Any)
            }
        }
        dataTask.resume()
        //  let geo = self.controllerUnderTest.geography
        
        waitForExpectations(timeout: 15, handler:nil)
        
    }
    
}
