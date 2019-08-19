//
//  FindCityViewController.swift
//  OpenWeatherApp
//
//  Created by Admin on 13/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import UIKit

final class FindCityViewController: UISearchController {

    var presenter: FindCityViewOutput!

    private var cityListView: CityListViewController {
        return self.searchResultsController as! CityListViewController
    }

    public init() {
        super.init(searchResultsController: CityListViewController.init())
        searchBar.placeholder = NSLocalizedString("City", comment: "")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = FindCityPresenter.init(with: self)

        self.searchBar.delegate = self
        self.searchResultsUpdater = self
        self.cityListView.delegte = self

        updateSearchResults(for: self)
    }
}

extension FindCityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.findBy(cityName: searchBar.text)
    }
}

extension FindCityViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        searchResultsController?.view.isHidden = false
        presenter.findBy(cityName: searchBar.text)
    }
}

extension FindCityViewController: CityListDelegate {

    func didSelectCurrentLocation() {
        presenter.currentLocationSelected()
    }

    func didSelectCity(city: City) {
        presenter.citySelected(city: city)
    }
}

extension FindCityViewController: FindCityViewInput {

    func configure(with cities: [City]) {
        cityListView.configure(with: cities)
    }

    func error(with message: String?) {
        if let actualMessage = message {
            showAlert(with: actualMessage)
        }
    }

    func startRefreshing() {
        NetworkActivityIndicator.add(caller: self)
    }

    func stopRefreshing() {
        NetworkActivityIndicator.remove(caller: self)
    }

    func close() {
        self.isActive = false
    }

}
