//
//  FiveDayForecastResponseTests.swift
//  OpenWeatherAppTests
//
//  Created by Admin on 07/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import XCTest
@testable import OpenWeatherApp

class FiveDayForecastResponseTests: XCTestCase {

    var jsonData: Data!

    override func setUp() {
        jsonData = FiveDayForecastResponse.sampleJSONString.data(using: .utf8)!
    }

    override func tearDown() {
    }

    func testDecode() {
        XCTAssertNoThrow(try JSONDecoder().decode(FiveDayForecastResponse.self, from: jsonData))
    }

}
