//
//  WheatherResponseTests.swift
//  OpenWeatherAppTests
//
//  Created by Admin on 07/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import XCTest
@testable import OpenWeatherApp

class CurrentWheatherResponseTests: XCTestCase {

    var jsonData: Data!

    override func setUp() {
        jsonData = CurrentWheatherResponse.sampleJSONString.data(using: .utf8)!
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecode() {
        XCTAssertNoThrow(try JSONDecoder().decode(CurrentWheatherResponse.self, from: jsonData))
    }

}
