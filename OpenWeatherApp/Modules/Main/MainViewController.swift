//
//  MainViewController.swift
//  OpenWeatherApp
//
//  Created by Admin on 10/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import UIKit
import SweetCells

final class MainViewController: UIViewController {
    
    var presenter: MainViewOutput!

    var city: City?

    var dateFomatter = DateFormatter.init()

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter(with: self)

        self.extendedLayoutIncludesOpaqueBars = true

        tableView.dataSource = self
        tableView.delegate = self

        tableView.registerCell(forClass: DailyForecastCell.self)
        tableView.registerCell(forClass: CurrentWeatherCell.self)

        let searchContoller = FindCityViewController.init()
        self.navigationItem.searchController = searchContoller
        searchContoller.delegate = self

        definesPresentationContext = true

        refreshControl = UIRefreshControl.init()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(MainViewController.refresh), for: .valueChanged)

        tableView.refreshControl = refreshControl
        
        presenter.viewLoaded()
        addObservers()
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewwillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc func viewDidEnterBackground() {
        self.presenter.viewEnterBackground()
    }

    @objc func viewwillEnterForeground() {
        self.presenter.reload()
    }

    @objc func refresh() {
        presenter.reload()
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    deinit {
        NetworkActivityIndicator.remove(caller: self)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDailyForecastViewController" {
            let dailyForecast = sender as? DailyForecast
            let viewController = segue.destination as? DailyForecastViewController
            viewController?.dailyForecast = dailyForecast
            viewController?.dateFormatter = dateFomatter
        }
    }

}

extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return city == nil ? 0 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fiveDayForecasts = city?.fiveDayForecasts {
            return fiveDayForecasts.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: DailyForecastCell.self, forIndexPath: indexPath)
        if let dailyForecast = city?.fiveDayForecasts?[indexPath.row] {
            cell.configure(with: dailyForecast, dateFormatter: dateFomatter)
        }
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let cell = tableView.dequeueReusableCell(withClass: CurrentWeatherCell.self) else {
                return nil
            }
            guard let weather = city?.currentWeather else {
                return nil
            }
            cell.configure(with: weather)
            return cell
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            guard let cell = tableView.dequeueReusableCell(withClass: OpenWeatherLinkCell.self) else {
                return nil
            }
            cell.dataProvidedLabel.text = NSLocalizedString("Data provided by", comment: "")
            return cell
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dailyForecast = city?.fiveDayForecasts?[indexPath.row] {
            self.performSegue(withIdentifier: "toDailyForecastViewController", sender: dailyForecast)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension MainViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        presenter.reload()
    }
}

extension MainViewController: MainViewInput {

    func configure(with city: City?) {
        self.city = city
        if let actualTimeZone = city?.timezone {
            self.dateFomatter.timeZone = actualTimeZone
        }
        self.reloadTableView()
        self.navigationItem.title = city?.name
    }

    func openSettings() {
        let localizedTitle = NSLocalizedString("Need location", comment: "")
        let localizedMessage = NSLocalizedString("You can go to settings to allow access", comment: "")
        let localizedSettings = NSLocalizedString("Settings", comment: "")
        let alertView = UIAlertController.init(title: localizedTitle, message: localizedMessage, preferredStyle: .alert)

        let setting = UIAlertAction.init(title: localizedSettings, style: .default) { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, completionHandler: nil)
            }
        }
        let cancel = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertView.addAction(setting)
        alertView.addAction(cancel)

        DispatchQueue.main.asyncAfter(deadline: .now() + alertPresentationDelay) {
            self.present(alertView, animated: true, completion: nil)
        }
    }

    func error(with message: String?) {
        if let actualMessage = message {
            showAlert(with: actualMessage)
        }
    }

    func startRefreshing() {
        NetworkActivityIndicator.add(caller: self)
        NetworkActivityIndicator.add(caller: NumberFormatter())
    }

    func stopRefreshing() {
        NetworkActivityIndicator.remove(caller: self)
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}
