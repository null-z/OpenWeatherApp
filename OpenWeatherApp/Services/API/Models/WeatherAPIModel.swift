//
//  Weather.swift
//  OpenWeatherApp
//
//  Created by Admin on 07/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

struct WeatherAPIModel: Decodable {
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}
