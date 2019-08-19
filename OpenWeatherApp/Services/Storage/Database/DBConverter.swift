//
//  DBConverter.swift
//  OpenWeatherApp
//
//  Created by Admin on 16/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import Realm

class DBConverter {

    static func domainModel(from city: DBCity) -> City? {
        let data = city.data
        if let actualData = data {
            return try? JSONDecoder().decode(City.self, from: actualData)
        } else {
            return nil
        }
    }

    static func dataBaseModel(from city: City) -> DBCity {
        let result = DBCity()
        result.id = city.id
        result.data = try? JSONEncoder().encode(city)
        return result
    }

    static func domainModel(from city: DBLastCity) -> City? {
        let data = city.data
        if let actualData = data {
            return try? JSONDecoder().decode(City.self, from: actualData)
        } else {
            return nil
        }
    }

    static func dataBaseLastCityModel(from city: City) -> DBLastCity {
        let result = DBLastCity()
        result.data = try? JSONEncoder().encode(city)
        return result
    }

}
