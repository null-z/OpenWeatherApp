//
//  AppDelegate.swift
//  OpenWeatherApp
//
//  Created by Admin on 06/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window?.tintColor = #colorLiteral(red: 0.9179999828, green: 0.4309999943, blue: 0.2939999998, alpha: 1)
        self.window?.backgroundColor = .darkGray

        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

