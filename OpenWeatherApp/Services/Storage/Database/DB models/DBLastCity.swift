//
//  DBLastCity.swift
//  OpenWeatherApp
//
//  Created by Admin on 17/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class DBLastCity: Object {

    static let uniqueKey: String = "lastCity"

    @objc dynamic var uniqueKey: String = DBLastCity.uniqueKey
    @objc dynamic var data: Data?

    override static func primaryKey() -> String? {
        return "uniqueKey"
    }
}
