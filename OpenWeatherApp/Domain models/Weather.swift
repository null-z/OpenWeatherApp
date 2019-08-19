//
//  Weather.swift
//  OpenWeatherApp
//
//  Created by Admin on 09/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let time: Date
    let shortDescription: String
    let icon: String
    let temperature: Double
    let pressure: Double
    let humidity: Double
    let wind: Wind

    var iconURL: URL? {
        let urlString = "https://openweathermap.org/img/wn/" + icon + "@2x.png"
        return URL(string: urlString)
    }
}
