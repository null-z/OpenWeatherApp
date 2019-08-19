//
//  WeatherSource.swift
//  OpenWeatherApp
//
//  Created by Admin on 15/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

enum WeatherSource: Equatable {
    case currentlocation
    case currentCityId(Int)
}

extension WeatherSource: Codable {

    enum Discriminator: String, Codable {
        case currentlocation, currentCityId
    }

    enum CodingKeys: String, CodingKey {
        case discriminator, currentlocation, currentCityId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let discriminator = try container.decode(Discriminator.self, forKey: .discriminator)
        switch discriminator {
        case .currentlocation:
            self = .currentlocation
        case .currentCityId:
            let id = try container.decode(Int.self, forKey: .currentCityId)
            self = .currentCityId(id)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .currentlocation:
            try container.encode(Discriminator.currentlocation, forKey: .discriminator)
        case .currentCityId(let id):
            try container.encode(Discriminator.currentCityId, forKey: .discriminator)
            try container.encode(id, forKey: .currentCityId)
        }
    }
}
