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
    var latPassed = 40.759211
    var lngPassed = -73.984638
    var namePassed = "test"
    let ref = FIRDatabase.database().reference(withPath: "data")
    var newLocs = [String]()
    var currentLat = 0.00
    var currentLng = 0.00

    
    var didFindMyLocation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: self.latPassed, longitude: self.lngPassed, zoom: 6.904)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        //marker2.snippet = "House"


        self.ref.child("locations").child((FIRAuth.auth()?.currentUser?.uid)!).observe(FIRDataEventType.value, with: { (snapshot) in
            let locDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            let selfMarker = GMSMarker()

            selfMarker.position = CLLocationCoordinate2D( latitude: Double(locDict["lat"] as! String)!, longitude: Double(locDict["lng"] as! String)! )
            selfMarker.icon = GMSMarker.markerImage(with: .black)
            selfMarker.title="You"
            selfMarker.map = mapView
            selfMarker.zIndex=10
        })
        
        ref.child("friends").child(FIRAuth.auth()?.currentUser?.uid as String!).observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            for item in dict {
                if (item.value as? NSNumber == 1 && item.key != FIRAuth.auth()?.currentUser?.uid) {
                    self.ref.child("locations").child(item.key).observe(FIRDataEventType.value, with: { (snapshot) in
                        let locDict = snapshot.value as? [String : AnyObject] ?? [:]
                        if ( locDict["name"] != nil  && locDict["lat"] != nil && locDict["lng"] != nil) {
                            let friendMarker = GMSMarker()
                            friendMarker.icon = GMSMarker.markerImage(with: .green)
                            friendMarker.position = CLLocationCoordinate2D( latitude: Double(locDict["lat"] as! String)!, longitude: Double(locDict["lng"] as! String)! )
                            friendMarker.title=(locDict["name"] as! String)
                            friendMarker.map = mapView
                            if ((locDict["name"] as! String) == self.namePassed) {
                                friendMarker.zIndex=10
                                mapView.selectedMarker=friendMarker
                            }
                        }
                    })
                }
            }
            let button = UIButton(frame: CGRect(x: 5, y: self.view.frame.size.height - 55, width: 100, height: 50))
            button.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            button.setTitle("Check in", for: .normal)
            button.addTarget(self, action: #selector(MapHomeViewController.sendLocAction), for: UIControlEvents.touchUpInside)
            
            let button2 = UIButton(frame: CGRect(x: self.view.frame.size.width - 105, y: self.view.frame.size.height - 55, width: 100, height: 50))
            button2.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            button2.setTitle("Friends", for: .normal)
            button2.addTarget(self, action: #selector(MapHomeViewController.goToFriends), for: UIControlEvents.touchUpInside)
            self.view.addSubview(button)
            self.view.addSubview(button2)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(MapHomeViewController.testing))

        })
        
        
//        ref.child("locations").observe(FIRDataEventType.value, with: { (snapshot) in
//            let dict = snapshot.value as? [String : AnyObject] ?? [:]
//            
//            for item in dict {
//                let marker = GMSMarker()
//                if ( item.value.object(forKey:"name") != nil  && item.value.object(forKey:"lng") != nil && item.value.object(forKey:"lat") != nil) {
//                    marker.position = CLLocationCoordinate2D( latitude: Double(item.value.object(forKey:"lat") as! String)!, longitude: Double(item.value.object(forKey:"lng") as! String)! )
//                    if (item.key==FIRAuth.auth()?.currentUser?.uid) {
//                        marker.icon = GMSMarker.markerImage(with: .black)
//                        marker.title="You"
//                    } else {
//                        marker.icon = GMSMarker.markerImage(with: .green)
//                        marker.title=(item.value.object(forKey:"name") as! String)
//                    }
//                    marker.map = mapView
//                    if ((item.value.object(forKey:"name") as! String) == self.namePassed) {
//                        mapView.selectedMarker=marker
//                    }
//                }
//            }
//        })
//

        
      
        /*
        let coordinate₀ = CLLocation(latitude: 5.0, longitude: 5.0)
        let coordinate₁ = CLLocation(latitude: 5.0, longitude: 3.0)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        print(distanceInMeters)
        print("asdfasdf")
        */
        
    }
    func testing() {
        print("SUIDHLFJKN")
        print("FUCK YEAH")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //    let lat = locations.last?.coordinate.latitude
   //     print(location!)
        self.currentLat=(locations.last?.coordinate.latitude)!
        self.currentLng=(locations.last?.coordinate.longitude)!
    }
    
     func logoutAction(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func goToFriends(){
        self.performSegue(withIdentifier: "MaptoTableSegue", sender: self)
    }
    
    @IBAction func sendLocAction(_ sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
        self.ref.child("locations").child((user?.uid)!).setValue(["lat": String(self.currentLat), "lng":String(currentLng), "name": "Spike"])
    }

}
