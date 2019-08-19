//
//  FindCityViewController.swift
//  OpenWeatherApp
//
//  Created by Admin on 11/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import UIKit
import SweetCells

final class CityListViewController: UITableViewController {

    let currentLocationSection = 0
    let citiesSection = 1

    var cities: [City]?

    var delegte: CityListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }

    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cities == nil ? 1 : 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case currentLocationSection:
            return 1
        case citiesSection:
            return cities == nil ? 0 : cities!.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case currentLocationSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentLocationCell") ?? UITableViewCell(style: .default,
                                                                                                               reuseIdentifier: "currentLocationCell")
            cell.imageView?.image = #imageLiteral(resourceName: "location")
            cell.imageView?.tintColor = .darkGray
            cell.textLabel?.text = NSLocalizedString("Current location", comment: "")
            cell.textLabel?.textColor = self.view.tintColor
            return cell
        case citiesSection:
            let city = cities![indexPath.row]
            let cell = tableView.dequeueReusableCell(withClass: CityCell.self, forIndexPath: indexPath)
            cell.configure(with: city)
            return cell
        default:
            return UITableViewCell()
        }
    }

    // MARK: - TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case currentLocationSection:
            delegte?.didSelectCurrentLocation()
        case citiesSection:
            let city = cities![indexPath.row]
            delegte?.didSelectCity(city: city)
        default:
            return
        }
    }

    func configure(with cities: [City]) {
        self.cities = cities
        tableView.reloadData()
    }
}

protocol CityListDelegate: class {
    func didSelectCurrentLocation()
    func didSelectCity(city: City)
}
