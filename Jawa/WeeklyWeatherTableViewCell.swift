//
//  WeeklyWeatherTableViewCell.swift
//  Jawa
//
//  Created by Mitul Manish on 27/06/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class WeeklyWeatherTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIButton!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
