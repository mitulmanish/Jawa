//
//  WeeklyWeather.swift
//  Jawa
//
//  Created by Mitul Manish on 27/06/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit



struct WeeklyWeather: JSONDecodable {
    
    let maxTemperature: Int?
    let minTemperature: Int?
    let humidity: Int?
    let precipChance: Int?
    let summary: String?
    var icon: UIImage? = UIImage(named: "default.png")
    var sunriseTime: String?
    var sunsetTime: String?
    var day: String?
    let dateFormatter = NSDateFormatter()
    
    var temperatureMaxCelcius: Int {
        return ((self.maxTemperature! - 32) * 5)/9
    }
    
    var temperatureMinCelcius: Int {
        return ((self.minTemperature! - 32) * 5)/9
    }
    
    var humidityString: String {
        return "\(humidity!)%"
    }
    
    var precipitationProbabilityString: String {
        return "\(precipChance!)%"
    }
    
    init?(JSON dailyWeatherDict: [String: AnyObject]) {
        
        maxTemperature = dailyWeatherDict["temperatureMax"] as? Int
        
        minTemperature = dailyWeatherDict["temperatureMin"] as? Int
        
        if let humidityFloat = dailyWeatherDict["humidity"] as? Double {
            humidity = Int(humidityFloat * 100)
        } else {
            humidity = nil
        }
        if let precipChanceFloat = dailyWeatherDict["precipProbability"] as? Double {
            precipChance = Int(precipChanceFloat * 100)
        } else {
            precipChance = nil
        }
        summary = dailyWeatherDict["summary"] as? String
       
        if let sunriseDate = dailyWeatherDict["sunriseTime"] as? Double {
            sunriseTime = timeStringFromUnixTime(sunriseDate)
        }
        if let sunsetDate = dailyWeatherDict["sunsetTime"] as? Double {
            sunsetTime = timeStringFromUnixTime(sunsetDate)
        }
        if let time = dailyWeatherDict["time"] as? Double {
            day = dayStringFromTime(time)
        }
        
        if let iconString = dailyWeatherDict["icon"] as? String {
            icon = WeatherIconFactory.toImage(iconString)
        }
        
    }

    
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func dayStringFromTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
    
}

extension WeeklyWeather {
    var temperatureMinString: String {
        return "\(temperatureMinCelcius)º↓"
    }
    
    var temperatureMaxString: String {
        return "↑\(temperatureMaxCelcius)º"
    }
}