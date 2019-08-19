//
//  APIResponse.swift
//  OpenWeatherApp
//
//  Created by Admin on 08/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

class APIResponse: Decodable {
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case message
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
    }
}
