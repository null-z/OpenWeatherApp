//
//  ViewDataFormatter.swift
//  OpenWeatherApp
//
//  Created by Admin on 17/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

class ViewDataFormatter {

    static let shared = ViewDataFormatter()

    private let temperatureFormatter: MeasurementFormatter
    private let pressureFormatter: MeasurementFormatter
    private let windSpeedFormatter: MeasurementFormatter
    private let humidityFormatter: NumberFormatter

    init() {
        temperatureFormatter = ViewDataFormatter.configuredTemperatureFormatter()
        pressureFormatter = ViewDataFormatter.configuredCommonFormatter()
        windSpeedFormatter = pressureFormatter
        humidityFormatter = ViewDataFormatter.configuredPercentFormatter()
    }

    private static func configuredTemperatureFormatter() -> MeasurementFormatter {
        let numberFormatter = NumberFormatter.init()
        numberFormatter.numberStyle = .none
        numberFormatter.positivePrefix = "+"

        let result = MeasurementFormatter.init()
        result.unitOptions = .init(arrayLiteral: .temperatureWithoutUnit)
        result.numberFormatter = numberFormatter
        return result
    }
    
    private static func configuredCommonFormatter() -> MeasurementFormatter {
        let numberFormatter = NumberFormatter.init()
        numberFormatter.numberStyle = .none

        let result = MeasurementFormatter.init()
        result.unitOptions = .providedUnit
        result.numberFormatter = numberFormatter
        return result
    }

    private static func configuredPercentFormatter() -> NumberFormatter {
        let result = NumberFormatter()
        result.numberStyle = .percent
        result.multiplier = 1
        return result
    }

    func stringFromTemperature(temperature: Double) -> String {
        let measurement = Measurement.init(value: temperature, unit: UnitTemperature.celsius)
        return temperatureFormatter.string(from: measurement)
    }

    func stringFromPressure(pressure: Double) -> String {
        let measurement = Measurement.init(value: pressure, unit: UnitPressure.hectopascals).converted(to: .millimetersOfMercury)
        return pressureFormatter.string(from: measurement)
    }

    func stringFromWindSpeed(windSpeed: Double) -> String {
        let measurement = Measurement.init(value: windSpeed, unit: UnitSpeed.metersPerSecond)
        return windSpeedFormatter.string(from: measurement)
    }

    func stringFromHumidity(humidity: Double) -> String {
        let number = NSNumber(value: humidity)
        if let result = humidityFormatter.string(from: number) {
            return result
        } else {
            return ""
        }
    }
}
