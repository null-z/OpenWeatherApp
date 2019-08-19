//
//  DataModelsTests.swift
//  OpenWeatherAppTests
//
//  Created by Admin on 07/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import XCTest

@testable import OpenWeatherApp

class DataModelsDecodingTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testType<T: JSONSamplable>(modelType: T.Type) {
        let data = modelType.sampleJSONString.data(using: .utf8)!
        XCTAssertNoThrow(try JSONDecoder().decode(modelType, from: data), "Decode fail")
    }

    func testCityAPIModelAPIModel() {
        testType(modelType: CityAPIModel.self)
    }

    func testMainAPIModel() {
        testType(modelType: MainAPIModel.self)
    }

    func testWeatherAPIModel() {
        testType(modelType: WeatherAPIModel.self)
    }

    func testThreeHourDataAPIModel() {
        testType(modelType: ThreeHourDataAPIModel.self)
    }


}
