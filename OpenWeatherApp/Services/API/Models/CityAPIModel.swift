//
//  CityAPIModel.swift
//  OpenWeatherApp
//
//  Created by Admin on 07/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

struct CityAPIModel: Decodable {
    let id: Int
    let name: String
    let timezoneOffset: Int?
    let country: String?

    enum CodingKeys: String, CodingKey {
        case id, name, country
        case timezoneOffset = "timezone"
    }
}
