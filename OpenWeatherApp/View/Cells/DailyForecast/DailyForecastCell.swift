//
//  DailyForecastCell.swift
//  OpenWeatherApp
//
//  Created by Admin on 11/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import UIKit
import Kingfisher
import SweetCells

class DailyForecastCell: UITableViewCell, AutoregistrableTableViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with forecast: DailyForecast, dateFormatter: DateFormatter) {
        dateFormatter.dateFormat = "EEEE"
        dayLabel.text = dateFormatter.string(from: forecast.date)
        dateFormatter.dateFormat = "d MMMM"
        dateLabel.text = dateFormatter.string(from: forecast.date)
        let middayForecast = forecast.middayForecast

        iconView.kf.setImage(with: middayForecast.iconURL)

        let temperature = ViewDataFormatter.shared.stringFromTemperature(temperature: middayForecast.temperature)
        temperatureLabel.text = temperature

    }
}
