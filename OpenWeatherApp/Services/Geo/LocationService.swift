//
//  LocationService.swift
//  OpenWeatherApp
//
//  Created by Admin on 09/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

enum LocationServiceError: Error {
    case restricted
    case denied
    case failed
    case cancelled
}

class LocationService: NSObject {

    public typealias Coordinates = (longitude: Double, latitude: Double)
    typealias Completion = (Coordinates) -> Void
    typealias Failure = (LocationServiceError) -> Void

    private static let locationManager = CLLocationManager()

    private var isUpdatingLocation = false

    private var completion: Completion?
    private var failure: Failure?

    override init() {
        super.init()
        LocationService.locationManager.delegate = self
        LocationService.locationManager.distanceFilter = 300
        LocationService.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation(completion: @escaping Completion, failure: @escaping Failure) {
        self.failure = failure
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            self.completion = completion
            LocationService.locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            self.completion = completion
            requestLocation()
        case .denied:
            failure(LocationServiceError.denied)
        case .restricted:
            failure(LocationServiceError.restricted)
        @unknown default:
            return
        }
    }

    private func requestLocation() {
        isUpdatingLocation = true
        LocationService.locationManager.requestLocation()
    }

    func cancel() {
        if isUpdatingLocation {
            LocationService.locationManager.stopUpdatingLocation()
            if let actualFailure = failure {
                actualFailure(LocationServiceError.cancelled)
            }
        }
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isUpdatingLocation = false
        if let actualFailure = failure {
            actualFailure(LocationServiceError.failed)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isUpdatingLocation = false
        let location = locations[0]
        if let actualCompletion = completion {
            let coordinates = (location.coordinate.longitude, location.coordinate.latitude)
            actualCompletion(coordinates)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        default:
            if let actualFailure = failure {
                actualFailure(LocationServiceError.failed)
            }
        }
    }
}
