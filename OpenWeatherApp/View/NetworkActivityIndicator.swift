//
//  UIApplication+NetworkActivity.swift
//  OpenWeatherApp
//
//  Created by Admin on 13/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import UIKit

class NetworkActivityIndicator {

    private static var callersTable: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    static func add(caller: AnyObject?) {
        callersTable.add(caller)
        updateState()
    }

    static func remove(caller: AnyObject?) {
        callersTable.remove(caller)
        updateState()
    }

    static func updateState() {
        if callersTable.allObjects.count == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            callersTable.removeAllObjects()
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
}
