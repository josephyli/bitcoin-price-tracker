//
//  DogecoinTrackerTests.swift
//  DogecoinTrackerTests
//
//  Created by Joseph Li on 10/4/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import XCTest
@testable import DogecoinTracker
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class DogecoinTrackerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()   
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: DogecoinTracker Tests
    // Tests to confirm that the Dogecointracker initializer returns when no name or a negative rating is provided.
    func testDogecoinTrackerInitialization() {
        // Success case.
        let potentialItem = DogecoinTracker(min: 1, max: 100, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle: 1)
        XCTAssertNotNil(potentialItem)
        
        // Failure cases.
        let bad1 = DogecoinTracker(min: -1, max: 100, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle: 1)
        XCTAssertNil(bad1, "Min is below zero")
        
        let bad2 = DogecoinTracker(min: 1, max: 0, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle: 1)
        XCTAssertNil(bad2, "Max is below min")

        let bad3 = DogecoinTracker(min: 1, max: 100, URL: "", cycle: 1)
        XCTAssertNil(bad3, "URL empty")
        
        let bad4 = DogecoinTracker(min: 1, max: 100, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle: 0)
        XCTAssertNil(bad4, "Cycle cannot be be 0 or below")

    }
    
    func testDogecoinTrackerGetOutput() {
        let tracker = DogecoinTracker(min: 310, max: 330, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle:5)
        let output = tracker?.getOutput()
        XCTAssertEqual((output >= 0.0 && output <= 0.4), true, "Output is out of range [0.0..0.4]")
    }
}
