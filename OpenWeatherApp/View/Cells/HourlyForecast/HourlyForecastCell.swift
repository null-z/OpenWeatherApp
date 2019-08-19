//
//  HourlyForecastCell.swift
//  OpenWeatherApp
//
//  Created by Admin on 11/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import UIKit
import SweetCells

class HourlyForecastCell: UITableViewCell, AutoregistrableTableViewCell {
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with weather: Weather, dateFormatter: DateFormatter) {
        dateFormatter.dateFormat = "H:mm"
        timeLabel.text = dateFormatter.string(from: weather.time)

        iconView.kf.setImage(with: weather.iconURL)
        descriptionLabel.text = weather.shortDescription.capitalizingFirstLetter

        let temperature = ViewDataFormatter.shared.stringFromTemperature(temperature: weather.temperature)
        let windSpeed = ViewDataFormatter.shared.stringFromWindSpeed(windSpeed: weather.wind.speed)
        let pressure = ViewDataFormatter.shared.stringFromPressure(pressure: weather.pressure)
        let humidity = ViewDataFormatter.shared.stringFromHumidity(humidity: weather.humidity)

        temperatureLabel.text = temperature
        windLabel.text = NSLocalizedString("Wind", comment: "") + " " + windSpeed + ", " + weather.wind.direction
        pressureLabel.text = NSLocalizedString("Pressure", comment: "") + " " + pressure
        humidityLabel.text = NSLocalizedString("Humidity", comment: "") + " " + humidity
    }
}
