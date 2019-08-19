//
//  DailyForecast.swift
//  OpenWeatherApp
//
//  Created by Admin on 09/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

struct DailyForecast: Codable {
    let date: Date
    let threeHourForecasts: [Weather]

    var middayForecast: Weather {
        if threeHourForecasts.count >= 5 {
            return threeHourForecasts[4]
        } else {
            return threeHourForecasts.last!
        }
    }
}
