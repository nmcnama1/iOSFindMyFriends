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
import FirebaseDatabase
import CoreLocation


class MapHomeViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    let ref = FIRDatabase.database().reference(withPath: "data")
    var newLocs = [String]();
    
    var didFindMyLocation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 1.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        //marker2.snippet = "House"

        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } /*else {
            let alertController = UIAlertController(title: "Error", message: "Location is null", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }*/
        
        ref.child("locations").observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            for item in dict {
                let marker = GMSMarker()
                print(item.value.object(forKey:"lat"))
                print(Double(item.value.object(forKey:"lng") as! String))

                marker.position = CLLocationCoordinate2D( latitude: Double(item.value.object(forKey:"lat") as! String)!, longitude: Double(item.value.object(forKey:"lng") as! String)! )
                marker.title=(item.value.object(forKey:"name") as! String)
                marker.map = mapView
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        print(location)
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
