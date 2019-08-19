//
//  Wind.swift
//  OpenWeatherApp
//
//  Created by Admin on 12/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

struct Wind: Codable {
    let speed: Double
    let degrees: Double

    var direction: String {
        var result = ""
        switch degrees {
        case 292.5...360, 0...67.5:
            result.append("N")
        case 112.5...247.5:
            result.append("S")
        default:
            break
        }
        switch degrees {
        case 22.5...157.5:
            result.append("E")
        case 202.5...337.5:
            result.append("W")
        default:
            break
        }
        return NSLocalizedString(result, comment: "")
    }
}
