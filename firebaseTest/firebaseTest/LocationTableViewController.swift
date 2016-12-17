//
//  LocationTableViewController.swift
//  firebaseTest
//
//  Created by SE Group 1 on 11/15/16.
//  Copyright © 2016 SEGroup1. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct info {
    var name = ""
    var id = ""
    var lat = "0.00"
    var lng = "0.00"
}

class LocationTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    var locs = [info]()
    var requests = [info]()
    var addFriend = "Add Friend"
    let ref = FIRDatabase.database().reference(withPath: "data")
    var passLat = 0.00
    var passLong = 0.00
    var passName = "test"
    var passID = ""
    var friendList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LocationTableViewController.longPress))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        self.locs = [info]()
        self.requests = [info]()
        ref.child("friends").child(FIRAuth.auth()?.currentUser?.uid as String!).observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            self.locs = [info]()
            self.requests = [info]()
            for item in dict {
               if (item.value as? NSNumber == 1 && item.key != FIRAuth.auth()?.currentUser?.uid) {
                    self.friendList.append(item.key)
                    self.ref.child("locations").child(item.key).observe(FIRDataEventType.value, with: { (snapshot) in
                        let locDict = snapshot.value as? [String : AnyObject] ?? [:]
                        if (locDict.count>0) {
                            let lat = (locDict["lat"] as! String);
                            let lng = (locDict["lng"] as! String);
                            let name = (locDict["name"] as! String);
                            let id = item.key
                        
                            var inform = info()
                            inform.name = name
                            inform.lat = lat
                            inform.lng = lng
                            inform.id = id;
                            self.locs.append(inform);
                            self.tableView.reloadData();
                        }
                    })
                }
               else if(item.value as? NSNumber == 2 && item.key != FIRAuth.auth()?.currentUser?.uid){
                    self.ref.child("locations").child(item.key).observe(FIRDataEventType.value, with: { (snapshot) in
                        let locDict = snapshot.value as? [String : AnyObject] ?? [:]
                    
                        let lat = "Unknown";
                        let lng = "Unknown";
                        let name = (locDict["name"] as! String);
                        let id = item.key;
                        
                        var inform = info()
                        inform.name = name
                        inform.lat = lat
                        inform.lng = lng
                        inform.id = id;
                        self.requests.append(inform);
                        self.tableView.reloadData();
                })
                }
            }
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(LocationTableViewController.goToSettings))

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(section == 1){
            return "Friend Requests";
        }
        else if(section == 2){
            return "Friends";
        }
        else if(section == 0){
            return nil;
        }
        else{
            return "SECTION"
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 1){
            return requests.count;
        }
        else if (section == 2){
            return locs.count;
        }
        else if(section == 0){
            return 1;
        }
        else{
            return 0;
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locCell", for: indexPath)

        // Configure the cell...
        if(indexPath.section == 1){
            cell.textLabel!.text = self.requests[indexPath.row].name;
            cell.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0);
        }
        else if(indexPath.section == 2){
            cell.textLabel!.text = self.locs[indexPath.row].name + ": (" + self.locs[indexPath.row].lat + ", " + self.locs[indexPath.row].lng + ")"
            if(indexPath.row % 2 == 0){
                cell.backgroundColor = UIColor.init(red: 0.85, green: 1.0, blue: 1.0, alpha: 1.0);
            }
            else{
                cell.backgroundColor = UIColor.init(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.0);
            }
            
        }
        else if(indexPath.section == 0){
            cell.textLabel?.text = "+   Add Friend";
            cell.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0);
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            ref.child("friends").child(FIRAuth.auth()?.currentUser?.uid as String!).child(requests[indexPath.row].id).setValue(1);
            ref.child("friends").child(requests[indexPath.row].id).child(FIRAuth.auth()?.currentUser?.uid as String!).setValue(1);
            requests.remove(at: indexPath.row);
        }
        
        //Friend is clicked
        if(indexPath.section == 2){
            
            self.passID = self.locs[indexPath.row].id;
            self.passLat = Double(self.locs[indexPath.row].lat)!
            self.passLong = Double(self.locs[indexPath.row].lng)!
            self.passName = self.locs[indexPath.row].name
            
            self.performSegue(withIdentifier: "tableToMapSegue", sender: "friendCell")
        }
        if(indexPath.section == 0){
            self.performSegue(withIdentifier: "addFriendSegue", sender: "addFriend");
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "addFriendSegue"){
            let vc = segue.destination as! AddFriendViewController;
            let controller = vc.popoverPresentationController;
            if(controller != nil){
                controller?.delegate = self;
                controller?.sourceView = self.view
                controller?.sourceRect = CGRect(x:self.view.bounds.midX, y: 0,width: 10,height: 10)
            }
        }
        else if(segue.identifier == "tableToMapSegue") {/*sender as! String == "friendCell") {*/
            let destinationVC = segue.destination as? MapHomeViewController
            destinationVC?.latPassed=self.passLat
            destinationVC?.lngPassed=self.passLong
            destinationVC?.namePassed=self.passName
        } else {
           let destinationVC = segue.destination as? SettingsTableViewController
            destinationVC?.cameFrom="Friends"
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none;
    }
    
    func goToSettings(){
        self.performSegue(withIdentifier: "FriendstoSettingsSegue", sender: "navButton")
    }
    
    
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                print(indexPath)
                if(indexPath[0]==2) {
                    print(indexPath)
                    self.passID = self.locs[indexPath[1]].id;
                    self.passLat = Double(self.locs[indexPath[1]].lat)!
                    self.passLong = Double(self.locs[indexPath[1]].lng)!
                    self.passName = self.locs[indexPath[1]].name
                    
                    // create the alert
                    let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete "+self.passName+" as your friend?", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: deleteFriend))
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                // your code here, get the row for the indexPath or do whatever you want
            }
        }
    }
    
    func deleteFriend(alert: UIAlertAction!) {
        ref.child("friends").child(FIRAuth.auth()?.currentUser?.uid as String!).child(self.passID).removeValue();
        ref.child("friends").child(self.passID).child(FIRAuth.auth()?.currentUser?.uid as String!).removeValue();
    }
}
