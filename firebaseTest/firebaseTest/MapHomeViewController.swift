//
//  MapHomeViewController.swift
//  firebaseTest
//
//  Created by Nancy Ann on 11/9/16.
//  Copyright © 2016 SEGroup1. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase


class MapHomeViewController: UIViewController {
    //let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        //locationManager.delegate = self
        //locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 1.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.isMyLocationEnabled = true
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        let marker2 = GMSMarker();
        marker2.position = CLLocationCoordinate2D(latitude: 38.897678, longitude: -77.036517)
        marker2.title = "White"
        marker2.snippet = "House"
        marker2.map = mapView
        mapView.isMyLocationEnabled = true
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            let alertController = UIAlertController(title: "Error", message: "Location is null", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        
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
