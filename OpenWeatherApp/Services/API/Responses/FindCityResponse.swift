//
//  FindCityResponse.swift
//  OpenWeatherApp
//
//  Created by Admin on 08/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

class FindCityResponse: APIResponse {
    let cities: [City]

    private enum CodingKeys: String, CodingKey {
        case list
    }

    private enum SysKeys: String, CodingKey {
        case country
    }

    private enum CityKeys: String, CodingKey {
        case id, name, country
        case sys
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        var cities: [City] = []
        var list = try container.nestedUnkeyedContainer(forKey: .list)
        while !list.isAtEnd {
            let item = try list.nestedContainer(keyedBy: CityKeys.self)
            let city = try FindCityResponse.cityFrom(container: item)
            cities.append(city)
        }
        self.cities = cities
        try super.init(from: decoder)
    }

    private static func cityFrom(container: KeyedDecodingContainer<FindCityResponse.CityKeys>) throws -> City {
        let sysContainer = try container.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)

        let country = (try? sysContainer.decode(String.self, forKey: .country))
        let id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        let name = try container.decode(String.self, forKey: .name)
        let timezone = TimeZone.init(secondsFromGMT: 0)
        let city = City(id: id, name: name, timezone: timezone, country: country)
        return city
    }
}
