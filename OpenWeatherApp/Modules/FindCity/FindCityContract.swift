//
//  FindCityContract.swift
//  OpenWeatherApp
//
//  Created by Admin on 14/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

protocol FindCityViewInput: class {

    func configure(with cities: [City])
    func error(with message: String?)
    func startRefreshing()
    func stopRefreshing()
    func close()
}

protocol FindCityViewOutput: class {

    func findBy(cityName: String?)
    func currentLocationSelected()
    func citySelected(city: City)
}
