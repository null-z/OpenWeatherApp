//
//  OpenWeatherMapAPIService.swift
//  OpenWeatherApp
//
//  Created by Admin on 06/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import Moya

private let appiId = "864277746416c0e28b044519de5e499e"
private let units = "metric"
private let language = Locale.current.languageCode ?? "ru"
private let defaultParameters = "APPID=\(appiId)&units=\(units)&lang=\(language)"
private let apiURL = "https://api.openweathermap.org/data/2.5/?\(defaultParameters)"

enum OpenWeatherMapAPIService {
    case getCurrentWeatherByCityId(Int)
    case getCurrentWeatherByCoordinates(longitude: Double, latitude: Double)

    case getFiveDaysForecastByCityId(Int)
    case getFiveDaysForecastByCoordinates(longitude: Double, latitude: Double)

    case findCityBy(name: String)
}

extension OpenWeatherMapAPIService: TargetType {
    var baseURL: URL {
        return URL(string: apiURL)!
    }

    var path: String {
        switch self {
        case .getCurrentWeatherByCityId(_), .getCurrentWeatherByCoordinates(_):
            return "weather"
        case .getFiveDaysForecastByCityId(_), .getFiveDaysForecastByCoordinates(_):
            return "forecast"
        case .findCityBy(name: _):
            return "find"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return "".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .findCityBy(let name):
            return .requestParameters(parameters: ["q": name], encoding: URLEncoding.queryString)
        case .getCurrentWeatherByCityId(let id), .getFiveDaysForecastByCityId(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        case .getCurrentWeatherByCoordinates(let coordinates), .getFiveDaysForecastByCoordinates(let coordinates):
            return .requestParameters(parameters: ["lat": coordinates.latitude, "lon": coordinates.longitude], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
