//
//  OpenWeatherLinkCell.swift
//  OpenWeatherApp
//
//  Created by Admin on 17/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import UIKit
import SweetCells

class OpenWeatherLinkCell: UITableViewCell, AutoregistrableTableViewCell {
    @IBOutlet weak var dataProvidedLabel: UILabel!
    @IBAction func linkButtonAction(_ sender: Any) {
        let link = URL(string: "https://openweathermap.org/")!
        UIApplication.shared.open(link, completionHandler: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
