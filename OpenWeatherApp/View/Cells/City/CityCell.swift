//
//  CityCell.swift
//  OpenWeatherApp
//
//  Created by Admin on 13/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import UIKit
import SweetCells

final class CityCell: UITableViewCell, AutoregistrableTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func flag(from country: String) -> String {
        let base: UInt32 = 127397
        var result = ""
        for scalar in country.uppercased().unicodeScalars {
            result.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
        }
        return result
    }

    func configure(with city: City) {
        nameLabel.text = city.name
        if let actualCountry = city.country {
            if let localizedCountry = Locale.current.localizedString(forRegionCode: actualCountry) {
                nameLabel.text?.append(", " + flag(from: actualCountry) + localizedCountry)
            }
        }
    }
}
