//
//  DetailedWeatherViewController.swift
//  Jawa
//
//  Created by Mitul Manish on 27/06/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class DetailedWeatherViewController: UIViewController {
    
    var currentDay: WeeklyWeather?
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainChanceLabel: UILabel!
    @IBOutlet weak var maximumTemperature: UILabel!
    @IBOutlet weak var minimumTemperature: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentDay = self.currentDay {
            setUpView(currentDay)
            setUpNavigationBarTitle(currentDay.day!)
        }
    }
    
    func setUpNavigationBarTitle(title: String) {
         self.navigationItem.title = title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpView(currentDay: WeeklyWeather) {
        humidityLabel.text = currentDay.humidityString
        rainChanceLabel.text = currentDay.precipitationProbabilityString
        maximumTemperature.text = currentDay.temperatureMaxString
        minimumTemperature.text = currentDay.temperatureMinString
        sunRiseLabel.text = currentDay.sunriseTime
        sunSetLabel.text = currentDay.sunsetTime
        summaryLabel.text = currentDay.summary
        weatherIcon.setImage(currentDay.icon, forState: .Normal)
    }
}
