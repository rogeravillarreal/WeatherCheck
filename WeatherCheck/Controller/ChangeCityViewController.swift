//
//  ChangeCityViewController.swift
//  WeatherCheck
//
//  Created by Roger Villarreal on 1/8/18.
//  Copyright © 2018 Roger Villarreal. All rights reserved.
//

import UIKit

protocol ChangedCityDelegate {
    func userEnteredNewCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate : ChangedCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!
    @IBOutlet weak var getWeatherButtonTapped: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    /**********************************************/

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func getWeatherPressed(_ sender: Any) {
        // get the city entered
        // if there is a delgate, call the function userEnteredNewCityName()
        // dismiss the VC
        let cityName = changeCityTextField.text!
        delegate?.userEnteredNewCityName(city: cityName)
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
