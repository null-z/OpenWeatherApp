//
//  Array+Split.swift
//  OpenWeatherApp
//
//  Created by Admin on 12/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation

extension Array {
    func split(whereDelimiter isDelimiter: (Element) throws -> Bool) rethrows -> [ArraySlice<Element>] {
        guard !isEmpty else { return [] }

        var slices = [ArraySlice<Element>]()
        var start = startIndex
        for (index, element) in self.enumerated() {
            let result = try isDelimiter(element)
            if result {
                let range = start...index
                let slice = self[range]
                slices.append(slice)
                start = index + 1
            }
        }
        return slices
    }
}
