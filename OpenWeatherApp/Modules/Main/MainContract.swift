//
//  MainContract.swift
//  OpenWeatherApp
//
//  Created by Admin on 10/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

protocol MainViewInput: class {

    func configure(with city: City?)
    func openSettings()
    func error(with message: String?)
    func startRefreshing()
    func stopRefreshing()
}

protocol MainViewOutput: class {

    func viewLoaded()
    func reload()
    func viewEnterBackground()
}
