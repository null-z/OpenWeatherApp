//
//  FindCityResponseTests.swift
//  OpenWeatherAppTests
//
//  Created by Admin on 08/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import XCTest
@testable import OpenWeatherApp

class FindCityResponseTests: XCTestCase {

    var jsonData: Data!

    override func setUp() {
        jsonData = FindCityResponse.sampleJSONString.data(using: .utf8)!
    }

    override func tearDown() {
    }

    func testDecode() {
        XCTAssertNoThrow(try JSONDecoder().decode(FindCityResponse.self, from: jsonData))
    }

}
