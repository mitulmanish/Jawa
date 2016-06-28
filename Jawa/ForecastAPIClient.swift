//
//  ForecastAPIClient.swift
//  Jawa
//
//  Created by Mitul Manish on 26/06/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation

enum WeatherSelection: String {
    case Daily = "daily"
    case Current = "currently"
}

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

enum Forecast: APIEndPoint {
    case Current(apiKey: String, locationCoordinate: Coordinate)
    
    var baseUrl: NSURL {
        return NSURL(string: "https://api.forecast.io")!
    }
    
    var path: String {
        switch self {
        case .Current(let apiKey, let location):
            return "/forecast/\(apiKey)/\(location.latitude),\(location.longitude)"
        }
    }
    
    var request: NSURLRequest {
        let url = NSURL(string: path, relativeToURL: baseUrl)!
        return NSURLRequest(URL: url)
    }
}

final class ForecastAPIClient: APIClient {

    let configuration: NSURLSessionConfiguration
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration)
    }()
    
    private let apiToken: String
    
    init(configuration: NSURLSessionConfiguration, apiKey: String) {
        self.configuration = configuration
        self.apiToken = apiKey
    }
    
    convenience init(apikey: String) {
        self.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), apiKey: apikey)
    }
    
    func fetchWeatherData(weatherSelection: WeatherSelection, coordinate: Coordinate, completion: APIResult<CurrentWeatherSnapShot> -> Void) {
        let request = Forecast.Current(apiKey: self.apiToken, locationCoordinate: coordinate).request
        
        fetch(request, parse: { (json) -> CurrentWeatherSnapShot? in
            
            if let currentWeatherDictionary = json[weatherSelection.rawValue] as? [String : AnyObject] {
               return CurrentWeatherSnapShot(JSON: currentWeatherDictionary)
            }
            else {
                return nil
            }
            
            }, completion: completion)
    }
    
    func fetchWeeklyWeatherData(weatherSelection: WeatherSelection, coordinate: Coordinate, completion: APIResult<DailyWeather> -> Void) {
        let request = Forecast.Current(apiKey: self.apiToken, locationCoordinate: coordinate).request
        
        fetch(request, parse: { (json) -> DailyWeather? in
            
            if let currentWeatherDictionary = json[weatherSelection.rawValue] as? [String : AnyObject] {
                return DailyWeather(JSON: currentWeatherDictionary)
            }
            else {
                return nil
            }
            
            }, completion: completion)
    }
}