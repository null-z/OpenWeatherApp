//
//  MainPresenter.swift
//  OpenWeatherApp
//
//  Created by Admin on 10/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

final class MainPresenter {

    unowned let view: MainViewInput

    let locationService = LocationService()
    let requester = FullWeatherRequester()

    init(with view: MainViewInput) {
        self.view = view
    }

    func getWeather() {
        locationService.cancel()
        requester.cancel()

        self.view.startRefreshing()

        switch WeatherSourceStorage.current {
        case .currentlocation:
            requestLocationAndWeather()
        case .currentCityId(let cityId):
            requestWeatherFor(cityId: cityId)
        }
    }

    func requestLocationAndWeather() {
        locationService.requestLocation(completion: { [weak self] (coordinates) in
            self?.requestWeatherFor(coordinates: coordinates)
        }, failure: { [weak self] (error) in
            self?.view.stopRefreshing()
            switch error {
            case .denied:
                self?.view.openSettings()
            case .restricted:
                self?.view.error(with: "Acces to current location is restricted")
            case .failed:
                break
            case .cancelled:
                break
            }
        })
    }

    private func requestWeatherFor(coordinates: LocationService.Coordinates) {
        requester.getAllWeatherBy(longitude: coordinates.longitude, latitude: coordinates.latitude, completion: { [weak self] (city) in
            self?.didLoadCity(city: city)
        }, failure: { [weak self] (error) in
            self?.didError(error: error)
        })
    }

    private func requestWeatherFor(cityId: Int) {
        requester.getAllWeatherBy(cityId: cityId, completion: { [weak self] (city) in
            self?.didLoadCity(city: city)
        }, failure: { [weak self] (error) in
            self?.didError(error: error)
        })
    }

    private func didLoadCity(city: City) {
        self.view.stopRefreshing()
        saveCityIfNeeded(city: city)
        self.view.configure(with: city)
    }

    private func didError(error: NetworkServiceError) {
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

    private func saveCityIfNeeded(city: City) {
        if case WeatherSource.currentCityId(let id) = WeatherSourceStorage.current {
            if id == city.id {
                DataBaseService.writeCity(city: city)
            }
        }
        DataBaseService.writeLastCity(city: city)
    }

    private func readLastCity() {
        DataBaseService.readLastCity { [weak self] (city) in
            self?.view.configure(with: city)
        }
    }

}

extension MainPresenter: MainViewOutput {

    func viewLoaded() {
        readLastCity()
        getWeather()
    }

    func reload() {
        getWeather()
    }

    func viewEnterBackground() {
        locationService.cancel()
        requester.cancel()
    }
}
