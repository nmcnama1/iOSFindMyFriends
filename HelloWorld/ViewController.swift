//
//  ViewController.swift
//  HelloWorld
//
//  Created by Nancy Ann on 10/9/16.
//  Copyright © 2016 Just me. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var locationInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        topLabel.text=textField.text
    }
    
    //MARK: Actions
    @IBAction func showMessage() {
        let alertController = UIAlertController(title: "Welcome", message: "Hello world!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func changeLabelText(_ sender: UIButton) {
        topLabel.text = "tester"
    }
    @IBAction func updateLocation(_ sender: UIButton) {
    }
}
