//
//  WeeklyWeatherTableTableViewController.swift
//  Jawa
//
//  Created by Mitul Manish on 27/06/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import CoreLocation

class WeeklyWeatherTableTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentWeatherStatusIcon: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentPrecipitation: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    
    var currentWeather: CurrentWeatherSnapShot!
    var weeklyWeatherList: [[String : AnyObject]]?
    var weeklyWeather: [WeeklyWeather] = []
    var foreCastAPIClient: ForecastAPIClient!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
        
        let defaultCoordinate = Coordinate(latitude: -37.8136, longitude: 144.9631)
        foreCastAPIClient = ForecastAPIClient(apikey: APIKey.WeatherForecast.rawValue)
        // if location access is not granted, use the location coordinates for Melbourne ❤️ , Australia
        checkPermission() ? fetchWeatherData(getLocationCoordinates()) : fetchWeatherData(defaultCoordinate)
        //fetchWeatherData(defaultCoordinate)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    private func fetchWeatherData(coordinate: Coordinate) {
        retreiveCurrentWeather(coordinate)
        retreiveWeeklyWeather(coordinate)
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    private func retreiveCurrentWeather(coordinate: Coordinate) {
        foreCastAPIClient.fetchWeatherData(.Current, coordinate: coordinate) { (apiResult) in
            switch apiResult {
            case .Success(let currentWeatherSnapShot):
                self.currentWeather = currentWeatherSnapShot
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUpView(self.currentWeather)
                }
            default: break
            }
        }
    }
    
    private func retreiveWeeklyWeather(coordinate: Coordinate) {
        foreCastAPIClient.fetchWeeklyWeatherData(.Daily, coordinate: coordinate) { (apiResult) in
            switch apiResult {
            case .Success(let dailyWeather):
                self.populateWeeklyWeather(dailyWeather)
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUpSunSetSunRise((self.weeklyWeather.first?.sunriseTime)!, sunSet: (self.weeklyWeather.first?.sunsetTime)!)
                    self.tableView.reloadData()
                }
            default: break
            }
        }
    }
    
    private func populateWeeklyWeather(dailyWeatherCollection: DailyWeather) {
        for day in dailyWeatherCollection.weeklyWeather {
            if let weekDay = WeeklyWeather(JSON: day) {
                self.weeklyWeather.append(weekDay)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weeklyWeather.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! WeeklyWeatherTableViewCell
        let currentDay = self.weeklyWeather[indexPath.row]
        
        if let dayName = currentDay.day {
            cell.dayLabel.text = indexPath.row == 0 ? DayName.PresentDay.rawValue : dayName
        }
        
        cell.maximumTemperatureLabel.text = currentDay.temperatureMaxString
        cell.minimumTemperatureLabel.text = currentDay.temperatureMinString
        cell.weatherIcon.setImage(currentDay.icon!, forState: .Normal)

        return cell
    }
    
    private func setUpView(currentWeather: CurrentWeatherSnapShot) {
        currentTemperatureLabel.text = currentWeather.temperatureString
        currentPrecipitation.text = currentWeather.precipitationProbabilityString
        currentHumidity.text = currentWeather.humidityString
        currentWeatherStatusIcon.setImage(currentWeather.currentWeatherIcon, forState: .Normal)
        summaryLabel.text = currentWeather.summary
    }
    
    private func setUpSunSetSunRise(sunRise: String, sunSet: String) {
        self.sunRiseLabel.text = sunRise
        self.sunSetLabel.text = sunSet
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! DetailedWeatherViewController
                destinationController.currentDay = self.weeklyWeather[indexPath.row]
            }
        }
    }
    
    enum DayName: String {
        case PresentDay = "Today"
    }
    
    private func getLocationCoordinates() -> Coordinate {
       return Coordinate(latitude: (locationManager.location?.coordinate.latitude)!,
                          longitude: (locationManager.location?.coordinate.longitude)!)
    }
    
    private func checkPermission() -> Bool {
        return (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways) ? true : false
    }
}



