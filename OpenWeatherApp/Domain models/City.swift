//
//  City.swift
//  OpenWeatherApp
//
//  Created by Admin on 09/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let timezone: TimeZone?
    let country: String?

    var currentWeather: Weather?
    var fiveDayForecasts: [DailyForecast]?

    init(id: Int, name: String, timezone: TimeZone?, country: String?) {
        self.id = id
        self.name = name
        self.timezone = timezone
        self.country = country
    }
}
