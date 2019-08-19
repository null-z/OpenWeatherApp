//
//  MainAPIModel.swift
//  OpenWeatherApp
//
//  Created by Admin on 07/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

struct MainAPIModel: Decodable {
    let temperature: Double
    let pressure: Double
    let humidity: Double

    enum CodingKeys: String, CodingKey {
        case pressure, humidity
        case temperature = "temp"
    }
}
