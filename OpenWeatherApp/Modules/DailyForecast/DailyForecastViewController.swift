//
//  DailyForecastViewController.swift
//  OpenWeatherApp
//
//  Created by Admin on 11/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import UIKit
import SweetCells

class DailyForecastViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var dailyForecast: DailyForecast!
    var dateFormatter: DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        dateFormatter.dateFormat = "d MMMM"
        navigationItem.title = dateFormatter.string(from: dailyForecast.date)
    }

}

extension DailyForecastViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast.threeHourForecasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = dailyForecast.threeHourForecasts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withClass: HourlyForecastCell.self, forIndexPath: indexPath)
        cell.configure(with: weather, dateFormatter: dateFormatter)
        return cell
    }
}
