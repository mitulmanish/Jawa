//
//  WeatherIconFactory.swift
//  Jawa
//
//  Created by Mitul Manish on 25/06/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit

struct WeatherIconFactory {
    
    static func toImage(iconName: String) -> UIImage {
        
        let imageName: String
        
        switch iconName {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy-day"
        case "partly-cloudy-night":
            imageName = "partly-cloudy-night"
        default:
            imageName = "default"
        }
        return UIImage(named: imageName)!
    }
    
}


