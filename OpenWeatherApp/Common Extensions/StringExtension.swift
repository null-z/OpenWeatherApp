//
//  StringExtension.swift
//  
//
//  Created by Admin on 11/08/2019.
//

import Foundation

extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }
}
