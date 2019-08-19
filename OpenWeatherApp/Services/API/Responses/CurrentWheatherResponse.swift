//
//  WeatherResponse.swift
//  OpenWeatherApp
//
//  Created by Admin on 06/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

class CurrentWheatherResponse: APIResponse {

    let city: City
    let weather: Weather

    private enum CodingKeys: String, CodingKey {
        case weather, main, wind, id, name, dt, timezone, sys
    }

    private enum SysCodingKeys: String, CodingKey {
        case country
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weather = try CurrentWheatherResponse.weatherFrom(container: container)
        self.city = try CurrentWheatherResponse.cityFrom(container: container)
        try super.init(from: decoder)
    }

    private static func weatherFrom(container: KeyedDecodingContainer<CurrentWheatherResponse.CodingKeys>) throws -> Weather {
        let weatherAPIModel = (try container.decode([WeatherAPIModel].self, forKey: .weather))[0]
        let windAPIModel = try container.decode(WindAPIModel.self, forKey: .wind)
        let mainAPIModel = try container.decode(MainAPIModel.self, forKey: .main)

        let timeInSeconds = try container.decode(Int.self, forKey: .dt)
        let time = Date(timeIntervalSince1970: TimeInterval(timeInSeconds))
        let shortDescription = weatherAPIModel.weatherDescription
        let icon = weatherAPIModel.icon

        let humidity = mainAPIModel.humidity
        let temperature = mainAPIModel.temperature
        let pressure = mainAPIModel.pressure

        let windSpeed = windAPIModel.speed
        let wind = Wind(speed: windSpeed, degrees: windAPIModel.deg)

        let weather = Weather(time: time,
                              shortDescription: shortDescription,
                              icon: icon,
                              temperature: temperature,
                              pressure: pressure,
                              humidity: humidity,
                              wind: wind)
        return weather
    }

    private static func cityFrom(container: KeyedDecodingContainer<CurrentWheatherResponse.CodingKeys>) throws -> City {
        let sysContainer = try container.nestedContainer(keyedBy: SysCodingKeys.self, forKey: .sys)

        let country = (try? sysContainer.decode(String.self, forKey: .country))
        let id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        let name = try container.decode(String.self, forKey: .name)
        let timezoneOffset = try? container.decode(Int.self, forKey: .timezone)
        var timezone: TimeZone?
        if let actualTimezoneOffset = timezoneOffset {
            timezone = TimeZone(secondsFromGMT: actualTimezoneOffset)
        }

        let city = City(id: id, name: name, timezone: timezone, country: country)
        return city
    }

}
