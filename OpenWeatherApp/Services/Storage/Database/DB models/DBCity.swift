//
//  DBCity.swift
//  OpenWeatherApp
//
//  Created by Admin on 16/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class DBCity: Object {

    @objc dynamic var id: Int = 0
    @objc dynamic var data: Data?

    override static func primaryKey() -> String? {
        return "id"
    }
}
