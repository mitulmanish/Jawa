//
//  CurrentWeatherSnapShot.swift
//  Jawa
//
//  Created by Mitul Manish on 25/06/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeatherSnapShot{
    let temperature: Double
    let humidity: Double
    let precipitationProbability: Double
    let summary: String
    let currentWeatherIcon: UIImage
    
    var temperatureCelcius: Double {
        return ((self.temperature - 32) * 5)/9
    }
}

extension CurrentWeatherSnapShot: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        
        guard let temperature = JSON["temperature"] as? Double,
            humidity = JSON["humidity"] as? Double,
            precipitationProbability = JSON["precipProbability"] as? Double,
            summary = JSON["summary"] as? String,
            iconString = JSON["icon"] as? String else {
                return nil
        }
        
        self.temperature = temperature
        self.humidity = humidity
        self.precipitationProbability = precipitationProbability
        self.summary = summary
        self.currentWeatherIcon = WeatherIconFactory.toImage(iconString)
    }
}

extension CurrentWeatherSnapShot {
    var temperatureString: String {
        return "\(Int(temperatureCelcius))º"
    }
    
    var humidityString: String {
        return "\(Int(humidity * 100))%"
    }
    
    var precipitationProbabilityString: String {
        return "\(Int(precipitationProbability * 100))%"
    }
}
