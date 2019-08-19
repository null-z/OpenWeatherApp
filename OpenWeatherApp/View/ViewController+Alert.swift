//
//  SilentAlert.swift
//  OpenWeatherApp
//
//  Created by Admin on 11/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    var alertPresentationDelay: DispatchTimeInterval {
        return DispatchTimeInterval.milliseconds(300)
    }

    func showAlert(with message: String) {
        let localizedMessage = NSLocalizedString(message, comment: "")
        let alertView = UIAlertController.init(title: nil, message: localizedMessage, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertView.addAction(ok)
        DispatchQueue.main.asyncAfter(deadline: .now() + alertPresentationDelay) { [weak self] in
            self?.present(alertView, animated: true, completion: nil)
        }
    }
}
