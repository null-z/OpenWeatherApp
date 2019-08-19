//
//  FindCityPresenter.swift
//  OpenWeatherApp
//
//  Created by Admin on 14/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

final class FindCityPresenter {

    unowned let view: FindCityViewInput

    let requester = FindCityRequester()

    init(with view: FindCityViewInput) {
        self.view = view
    }

    func didLoadCities(cities: [City]) {
        self.view.stopRefreshing()
        self.view.configure(with: cities)
    }

    func didError(error: NetworkServiceError) {
        self.view.stopRefreshing()
        switch error {
        case .anyError(let message):
            self.view.error(with: message)
        case .noConnection:
            self.view.error(with: "No network connection")
        case .cancelled:
            break
        }
    }
}

extension FindCityPresenter: FindCityViewOutput {

    func findBy(cityName: String?) {
        requester.cancel()
        if let actualCityName = cityName {
            let cityNameWithoutSpaces = actualCityName.trimmingCharacters(in: .whitespaces)
            if cityNameWithoutSpaces.isEmpty || actualCityName.count < 3 {
                let cities = DataBaseService.readCities()
                view.configure(with: cities)
            } else {
                self.view.startRefreshing()
                requester.getCitiesBy(name: actualCityName, delayInSeconds: 1, completion: { [weak self] (cities) in
                    self?.didLoadCities(cities: cities)
                }, failure: { [weak self] (error) in
                    self?.didError(error: error)
                })
            }
        }
    }

    func currentLocationSelected() {
        WeatherSourceStorage.save(type: .currentlocation)
        view.close()
    }

    func citySelected(city: City) {
        WeatherSourceStorage.save(type: .currentCityId(city.id))
        view.close()
    }
}
