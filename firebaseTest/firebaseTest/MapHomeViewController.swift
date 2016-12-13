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
    var markers = [GMSMarker]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var mapView = GMSMapView()
    
    var didFindMyLocation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        print(appDelegate.sharing)
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: self.latPassed, longitude: self.lngPassed, zoom: 6.904)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = self.mapView
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        //marker2.snippet = "House"

        let selfMarker = GMSMarker()

        self.ref.child("locations").child((FIRAuth.auth()?.currentUser?.uid)!).observe(FIRDataEventType.value, with: { (snapshot) in
            let locDict = snapshot.value as? [String : AnyObject] ?? [:]
            if (locDict.count != 0 ) {
                selfMarker.position = CLLocationCoordinate2D( latitude: Double(locDict["lat"] as! String)!, longitude: Double(locDict["lng"] as! String)! )
                selfMarker.icon = GMSMarker.markerImage(with: .black)
                selfMarker.title="You" //should this say me?
                selfMarker.map = self.mapView
                selfMarker.zIndex=9
            } else {
                selfMarker.map = nil
            }
        })
        
        ref.child("locations").observe(FIRDataEventType.value, with: { (snapshot) in
            self.resetFriendMarkers()
            })
        ref.child("friends").child((FIRAuth.auth()?.currentUser?.uid)!).observe(FIRDataEventType.value, with: { (snapshot) in
            self.resetFriendMarkers()
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(MapHomeViewController.goToSettings))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(MapHomeViewController.hideBackButton))

        self.navigationItem.setHidesBackButton(true, animated: false)
        /*
        let coordinate₀ = CLLocation(latitude: 5.0, longitude: 5.0)
        let coordinate₁ = CLLocation(latitude: 5.0, longitude: 3.0)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        print(distanceInMeters)
        print("asdfasdf")
        */
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as? SettingsTableViewController
        destinationVC?.cameFrom="Map"
    }
 
    
    func goToFriends(){
        self.performSegue(withIdentifier: "MaptoTableSegue", sender: self)
    }
    
    func goToSettings(){
        self.performSegue(withIdentifier: "MaptoSettings_Segue", sender: self)
    }
    
    @IBAction func sendLocAction(_ sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
        var name=""
        ref.child("users").child((user?.uid)!).observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            name=dict["name"] as! String
            self.ref.child("locations").child((user?.uid)!).setValue(["lat": String(self.currentLat), "lng":String(self.currentLng), "name": name])
        })
        
    }
    
    func resetFriendMarkers() {
        for marker in self.markers {
            marker.map=nil
        }
        self.ref.child("friends").child(FIRAuth.auth()?.currentUser?.uid as String!).observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            for item in dict {
                if (item.value as? NSNumber == 1 && item.key != FIRAuth.auth()?.currentUser?.uid) {
                    self.ref.child("locations").child(item.key).observe(FIRDataEventType.value, with: { (snapshot) in
                        let locDict = snapshot.value as? [String : AnyObject] ?? [:]
                        if ( locDict["name"] != nil  && locDict["lat"] != nil && locDict["lng"] != nil) {
                            let friendMarker = GMSMarker()
                            self.markers.append(friendMarker)
                            friendMarker.icon = GMSMarker.markerImage(with: .green)
                            friendMarker.position = CLLocationCoordinate2D( latitude: Double(locDict["lat"] as! String)!, longitude: Double(locDict["lng"] as! String)! )
                            friendMarker.title=(locDict["name"] as! String)
                            friendMarker.map = self.mapView
                            if ((locDict["name"] as! String) == self.namePassed) {
                                friendMarker.zIndex=10
                                self.mapView.selectedMarker=friendMarker
                            }
                        }
                    })
                }
            }
            if (self.appDelegate.sharing) {
                let checkinButton = UIButton(frame: CGRect(x: 110, y: self.view.frame.size.height - 55, width: 100, height: 50))
                checkinButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
                checkinButton.setTitle("Check in", for: .normal)
                checkinButton.addTarget(self, action: #selector(MapHomeViewController.sendLocAction), for: UIControlEvents.touchUpInside)
                self.view.addSubview(checkinButton)
            }
            
            let friendsButton = UIButton(frame: CGRect(x: 5, y: self.view.frame.size.height - 55, width: 100, height: 50))
            friendsButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            friendsButton.setTitle("Friends", for: .normal)
            friendsButton.addTarget(self, action: #selector(MapHomeViewController.goToFriends), for: UIControlEvents.touchUpInside)
            self.view.addSubview(friendsButton)
            
        })
    }
    
    func hideBackButton() {
    }

}
