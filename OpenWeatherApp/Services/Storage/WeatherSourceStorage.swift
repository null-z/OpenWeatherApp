//
//  WeatherSource.swift
//  OpenWeatherApp
//
//  Created by Admin on 10/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

class WeatherSourceStorage {

    private static let userDefaultsKey = "CurrentWeatherSource"

    static var current: WeatherSource {
        get {
            if let result = self.load() {
                return result
            } else {
                return self.defaultType()
            }
        }
        set {
            save(type: newValue)
        }
    }

    static func defaultType() -> WeatherSource {
        return WeatherSource.currentlocation
    }

    static func save(type: WeatherSource) {
        guard let data = try? JSONEncoder().encode(type) else {
            return
        }
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }

    static func load() -> WeatherSource? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return nil
        }
        guard let type = try? JSONDecoder().decode(WeatherSource.self, from: data) else {
            return nil
        }
        return type
    }
}
