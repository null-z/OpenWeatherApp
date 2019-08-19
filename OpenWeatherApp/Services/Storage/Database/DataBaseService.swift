//
//  DataBaseService.swift
//  OpenWeatherApp
//
//  Created by Admin on 16/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseService {

    private static let realm = try? Realm()

    static func writeCity(city: City) {
        let dbCity = DBConverter.dataBaseModel(from: city)
        try? realm?.write {
            realm?.add(dbCity, update: .all)
        }
    }

    static func readCity(for id: Int) -> City? {
        let dbCity = realm?.object(ofType: DBCity.self, forPrimaryKey: id)
        if let actualDBCity = dbCity {
            return DBConverter.domainModel(from: actualDBCity)
        } else {
            return nil
        }
    }

    static func readCities() -> [City] {
        let result = realm?.objects(DBCity.self)
        if let actualResult = result {
            return actualResult.compactMap({ (dbCity) -> City? in
                return DBConverter.domainModel(from: dbCity)
            })
        } else {
            return []
        }
    }

    static func writeLastCity(city: City) {
        let dbCity = DBConverter.dataBaseLastCityModel(from: city)
        try? realm?.write {
            realm?.add(dbCity, update: .all)
        }
    }

    static func readLastCity(completion: (City?) -> Void ) {
        let dbCity = realm?.object(ofType: DBLastCity.self, forPrimaryKey: DBLastCity.uniqueKey)
        if let actualDBCity = dbCity {
            let lastCity = DBConverter.domainModel(from: actualDBCity)
            completion(lastCity)
        } else {
            completion(nil)
        }
    }

}
