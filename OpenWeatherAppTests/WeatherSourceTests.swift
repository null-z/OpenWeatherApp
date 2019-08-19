//
//  WeatherSourceTests.swift
//  OpenWeatherAppTests
//
//  Created by Admin on 15/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import XCTest
@testable import OpenWeatherApp

class WeatherSourceTests: XCTestCase {

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let id = 152

    override func setUp() {
    }

    override func tearDown() {
    }

    func testEncodeCurrentLocationCase() {
        let weatherSource = WeatherSource.currentlocation
        XCTAssertNoThrow(try encoder.encode(weatherSource))
    }

    func testEncodeCurrentCityIdCase() {
        let weatherSource = WeatherSource.currentCityId(id)
        XCTAssertNoThrow(try encoder.encode(weatherSource))
    }

    func testDecodeCurrentLocationCase() {
        let data = try! encoder.encode(WeatherSource.currentlocation)
        var decodingResult: WeatherSource!
        XCTAssertNoThrow(decodingResult = try! decoder.decode(WeatherSource.self, from: data))
        XCTAssertEqual(WeatherSource.currentlocation, decodingResult)
    }

    func testDecodeCurrentCityIdCase() {
        let data = try! encoder.encode(WeatherSource.currentCityId(id))
        var decodingResult: WeatherSource!
        XCTAssertNoThrow(decodingResult = try! decoder.decode(WeatherSource.self, from: data))
        XCTAssertEqual(WeatherSource.currentCityId(id), decodingResult)
        if case let WeatherSource.currentCityId(decodedId)? = decodingResult {
            XCTAssertEqual(id, decodedId)
        }
    }

}
