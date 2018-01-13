//
//  ViewController.swift
//  WeatherCheck
//
//  Created by Roger Villarreal on 12/26/17.
//  Copyright © 2017 Roger Villarreal. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangedCityDelegate {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "56d468b60eaea6d040954f019dc873a8"
    
    // Declare instance variable
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    // MARK: - Actions
    /*********************************************/
    @IBAction func switchTapped(_ sender: UISwitch) {
        if sender.isOn {
            temperatureLabel.text = String((weatherDataModel.temperature * 9) / 5 + 32 ) + "℉"
        } else {
            temperatureLabel.text = String(weatherDataModel.temperature) + "℃"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up the location manager.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Networking
    /*********************************************/
    func getWeatherData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success, got the Weather Data!")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON) // need self to check for method inside class
            }
            else {
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    // MARK: - JSON Parsing
    /*********************************************/
    
    func updateWeatherData(json: JSON) {
        
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.temperature = Int(tempResult - 273.15) // kelving to Celsius
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    // MARK: - UI Updates
    /*********************************************/
    func updateUIWithWeatherData() {
        temperatureLabel.text = String(weatherDataModel.temperature) + "℃"
        cityLabel.text = weatherDataModel.city
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    // MARK: - Location Manager Delegate Methods
    /*********************************************/
    
    // Update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1] // get last item of array, most accurate
        if locations.count > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil // stops from printing multiple times
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lon": longitude, "lat": latitude, "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    // if fails with error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    // MARK: - Changed City Delegate Methods
    /*********************************************/
    
    func userEnteredNewCityName(city: String) {
        let params = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params )
        updateUIWithWeatherData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self // Why call delegate here??
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

