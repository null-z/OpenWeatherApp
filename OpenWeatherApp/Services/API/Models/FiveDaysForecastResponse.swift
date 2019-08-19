//
//  FiveDaysForecastResponse.swift
//  OpenWeatherApp
//
//  Created by Admin on 06/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

// MARK: - FiveDayForecastResponse
struct FiveDayForecastResponse: Decodable {
    let list: [List]
    let city: City
}
