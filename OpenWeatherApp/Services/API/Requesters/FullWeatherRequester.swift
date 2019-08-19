//
//  FullWeatherRequest.swift
//  OpenWeatherApp
//
//  Created by Admin on 15/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import Moya

class FullWeatherRequester {

    typealias Completion = (City) -> Void
    typealias Failure = (NetworkServiceError) -> Void

    private var cancellables: [Cancellable] = []

    func getAllWeatherBy(cityId: Int, completion: @escaping Completion, failure: @escaping Failure) {
        var firstResponse: CurrentWheatherResponse?
        var secondResponse: FiveDayForecastResponse?
        var requestError: NetworkServiceError?

        let group = DispatchGroup()

        group.enter()
        let firstCancellable = APIService.getCurrentWeatherBy(cityId: cityId, completion: { (result) in
            switch result {
            case .success(let response):
                firstResponse = response
            case .failure(let error):
                requestError = error
            }
            group.leave()
        })
        cancellables.append(firstCancellable)

        group.enter()
        let secondCancellable = APIService.getFiveDaysForecastBy(cityId: cityId, completion: { (result) in
            switch result {
            case .success(let response):
                secondResponse = response
            case .failure(let error):
                requestError = error
            }
            group.leave()
        })
        cancellables.append(secondCancellable)

        group.notify(queue: .main) {
            if let actualError = requestError {
                failure(actualError)
            } else if let currentWeatherResponse = firstResponse, let fiveDayForecastResponse = secondResponse {
                var city = currentWeatherResponse.city
                city.currentWeather = currentWeatherResponse.weather
                city.fiveDayForecasts = fiveDayForecastResponse.fiveDayForecasts
                completion(city)
            }
        }
    }

    func getAllWeatherBy(longitude: Double, latitude: Double, completion: @escaping Completion, failure: @escaping Failure) {
        var firstResponse: CurrentWheatherResponse?
        var secondResponse: FiveDayForecastResponse?
        var requestError: NetworkServiceError?

        let group = DispatchGroup()

        group.enter()
        let firstCancellable = APIService.getCurrentWeatherByCoordinates(longitude: longitude, latitude: latitude, completion: { (result) in
            switch result {
            case .success(let response):
                firstResponse = response
            case .failure(let error):
                requestError = error
            }
            group.leave()
        })
        cancellables.append(firstCancellable)

        group.enter()
        let secondCancellable = APIService.getFiveDaysForecastByCoordinates(longitude: longitude, latitude: latitude, completion: { (result) in
            switch result {
            case .success(let response):
                secondResponse = response
            case .failure(let error):
                requestError = error
            }
            group.leave()
        })
        cancellables.append(secondCancellable)

        group.notify(queue: .main) {
            if let actualError = requestError {
                failure(actualError)
            } else if let currentWeatherResponse = firstResponse, let fiveDayForecastResponse = secondResponse {
                var city = currentWeatherResponse.city
                city.currentWeather = currentWeatherResponse.weather
                city.fiveDayForecasts = fiveDayForecastResponse.fiveDayForecasts
                completion(city)
            }
        }
    }

    func cancel() {
        cancellables.forEach { (item) in
            item.cancel()
        }
        cancellables.removeAll()
    }

    deinit {
        cancel()
    }
}
