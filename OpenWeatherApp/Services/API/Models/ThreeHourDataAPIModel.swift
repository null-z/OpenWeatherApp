//
//  ThreeHourDataAPIModel.swift
//  OpenWeatherApp
//
//  Created by Admin on 07/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

struct ThreeHourDataAPIModel: Decodable {
    let weather: [WeatherAPIModel]
    let main: MainAPIModel
    let wind: WindAPIModel
    let dt: Int

    enum CodingKeys: String, CodingKey {
        case main, weather, dt, wind
    }
}
