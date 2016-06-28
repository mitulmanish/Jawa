//
//  DailyWeather.swift
//  Jawa
//
//  Created by Mitul Manish on 27/06/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
struct DailyWeather: JSONDecodable {
    
    let weeklyWeather: [[String: AnyObject]]
    let weeklySummary: String
    let weeklyIcon: String
    
    init?(JSON: [String : AnyObject]) {
        
        guard let weeklyWeatherList = JSON["data"] as? [[String : AnyObject]],
            weeklySummary = JSON["summary"] as? String, weeklyIcon = JSON["icon"] as? String else {
                return nil
        }
        
        self.weeklyWeather = weeklyWeatherList
        self.weeklySummary = weeklySummary
        self.weeklyIcon = weeklyIcon
    }
}