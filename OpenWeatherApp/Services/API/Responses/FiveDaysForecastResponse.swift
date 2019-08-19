//
//  FiveDaysForecastResponse.swift
//  OpenWeatherApp
//
//  Created by Admin on 06/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

// MARK: - FiveDayForecastResponse
class FiveDayForecastResponse: APIResponse {
    
    let fiveDayForecasts: [DailyForecast]
    let city: City

    private enum CodingKeys: String, CodingKey {
        case list, city
    }

    private enum SysCodingKeys: String, CodingKey {
        case country
    }

    enum CityCodingKeys: String, CodingKey {
        case id, name, country, timezone
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.city = try FiveDayForecastResponse.cityFrom(container: container)
        self.fiveDayForecasts = try FiveDayForecastResponse.fiveDayForecastsFrom(container: container, timezone: self.city.timezone)
        try super.init(from: decoder)
    }

    private static func fiveDayForecastsFrom(container: KeyedDecodingContainer<FiveDayForecastResponse.CodingKeys>,
                                             timezone: TimeZone?) throws -> [DailyForecast] {
        let list = try container.decode([ThreeHourDataAPIModel].self, forKey: .list)

        let weathers = list.map { (model) -> Weather in
            let time = Date(timeIntervalSince1970: TimeInterval(model.dt))
            let description = model.weather[0].weatherDescription
            let icon = model.weather[0].icon

            let humidity = model.main.humidity
            let temperature = model.main.temperature
            let pressure = model.main.pressure
            let windSpeed = model.wind.speed

            let wind = Wind(speed: windSpeed, degrees: model.wind.deg)

            let weather = Weather(time: time,
                                  shortDescription: description,
                                  icon: icon,
                                  temperature: temperature,
                                  pressure: pressure,
                                  humidity: humidity,
                                  wind: wind)
            return weather
        }

        var calendar = Calendar.init(identifier: Calendar.current.identifier)
        let actualTimeZone = timezone ?? TimeZone.init(secondsFromGMT: 0)!
        calendar.timeZone = actualTimeZone

        let splittedWeathers = weathers.split(whereDelimiter: { (weather) -> Bool in
            let nextTime = calendar.date(byAdding: .hour, value: 3, to: weather.time)!
            if !calendar.isDate(weather.time, inSameDayAs: nextTime) {
                return true
            } else {
                return false
            }
        })

        let dailyForecasts = splittedWeathers.map { (slice) -> DailyForecast in
            let array = Array(slice)
            let firstWeather = array[0]
            let date = firstWeather.time
            let dailyForecast = DailyForecast(date: date, threeHourForecasts: array)
            return dailyForecast
        }

        return dailyForecasts
    }

    private static func cityFrom(container: KeyedDecodingContainer<FiveDayForecastResponse.CodingKeys>) throws -> City {
        let cityContainer = try container.nestedContainer(keyedBy: CityCodingKeys.self, forKey: .city)

        let country = try? cityContainer.decode(String.self, forKey: .country)
        let id = (try? cityContainer.decode(Int.self, forKey: .id)) ?? 0
        let name = (try? cityContainer.decode(String.self, forKey: .name)) ?? ""
        let timezoneOffset = try? cityContainer.decode(Int.self, forKey: .timezone)
        var timezone: TimeZone?
        if let actualTimezoneOffset = timezoneOffset {
            timezone = TimeZone(secondsFromGMT: actualTimezoneOffset)
        }

        let city = City(id: id, name: name, timezone: timezone, country: country)
        return city
    }
}
