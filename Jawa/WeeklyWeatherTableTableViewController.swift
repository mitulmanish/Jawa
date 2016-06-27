//
//  WeeklyWeatherTableTableViewController.swift
//  Jawa
//
//  Created by Mitul Manish on 27/06/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class WeeklyWeatherTableTableViewController: UITableViewController {
    
    @IBOutlet weak var currentWeatherStatusIcon: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentPrecipitation: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    
    private let apiKey = "c96b1383d1efcd33ea8e9f24e6b49502"
    var coordinate: Coordinate?
    var currentWeather: CurrentWeatherSnapShot!
    var weeklyWeatherList : [[String : AnyObject]]?
    var weeklyWeather: [WeeklyWeather] = []
    var foreCastAPIClient: ForecastAPIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinate = Coordinate(latitude: -37.8136, longitude: 144.9631)
        foreCastAPIClient = ForecastAPIClient(apikey: apiKey)
        retreiveCurrentWeather(coordinate!)
        retreiveWeeklyWeather(coordinate!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    func retreiveCurrentWeather(coordinate: Coordinate) {
        foreCastAPIClient.fetchWeatherData(.Current, coordinate: coordinate) { (apiResult) in
            switch apiResult {
            case .Success(let currentWeatherSnapShot):
                dispatch_async(dispatch_get_main_queue()) {
                    self.currentWeather = currentWeatherSnapShot
                    self.setUpView(self.currentWeather)
                }
            default: break
            }
        }
    }
    
    func retreiveWeeklyWeather(coordinate: Coordinate) {
        foreCastAPIClient.fetchWeeklyWeatherData(.Daily, coordinate: coordinate) { (apiResult) in
            switch apiResult {
            case .Success(let dailyWeather):
                dispatch_async(dispatch_get_main_queue()) {
                    
                    for day in dailyWeather.weeklyWeather  {
                        let certainDay = WeeklyWeather(JSON: day)
                        if let weekDay = certainDay {
                            self.weeklyWeather.append(weekDay)
                        }
                        
                        self.tableView.reloadData()
                        self.setUpSunSetSunRise((self.weeklyWeather.first?.sunriseTime)!, sunSet: (self.weeklyWeather.first?.sunsetTime)!)
                    }
                }
            default: break
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
            cell.dayLabel.text = dayName
        }
        
        cell.maximumTemperatureLabel.text = currentDay.temperatureMaxString
        cell.minimumTemperatureLabel.text = currentDay.temperatureMinString
        cell.weatherIcon.setImage(currentDay.icon!, forState: .Normal)

        return cell
    }
    
    func setUpView(currentWeather: CurrentWeatherSnapShot) {
        currentTemperatureLabel.text = currentWeather.temperatureString
        currentPrecipitation.text = currentWeather.precipitationProbabilityString
        currentHumidity.text = currentWeather.humidityString
        currentWeatherStatusIcon.setImage(currentWeather.currentWeatherIcon, forState: .Normal)
        summaryLabel.text = currentWeather.summary
    }
    
    func setUpSunSetSunRise(sunRise: String, sunSet: String) {
        self.sunRiseLabel.text = sunRise
        self.sunSetLabel.text = sunSet
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! DetailedWeatherViewController
                destinationController.currentDay = self.weeklyWeather[indexPath.row]
            }
        }
    }
}



