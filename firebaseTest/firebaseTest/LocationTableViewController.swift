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

class LocationTableViewController: UITableViewController {
    var locs = [info]()
    var requests = [info]()
    let ref = FIRDatabase.database().reference(withPath: "data")
    var passLat = 0.00
    var passLong = 0.00
    var passName = "test"
   // var user = FIRAuth.auth()?.currentUser
    var friendList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FIRAuth.auth()?.currentUser?.uid as String!)

        self.locs = [info]()
        self.requests = [info]()
        ref.child("friends").child(FIRAuth.auth()?.currentUser?.uid as String!).observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            self.locs = [info]()
            for item in dict {
               if (item.value as? NSNumber == 1 && item.key != FIRAuth.auth()?.currentUser?.uid) {
                    self.friendList.append(item.key)
                    self.ref.child("locations").child(item.key).observe(FIRDataEventType.value, with: { (snapshot) in
                        let locDict = snapshot.value as? [String : AnyObject] ?? [:]
                    
                        let lat = (locDict["lat"] as! String);
                        let lng = (locDict["lng"] as! String);
                        let name = (locDict["name"] as! String);
                        let id = item.key;
                        
                        var inform = info()
                        inform.name = name
                        inform.lat = lat
                        inform.lng = lng
                        inform.id = id;
                        self.locs.append(inform);
                        self.tableView.reloadData();
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


        let button = UIButton(frame: CGRect(x: 5, y: self.view.frame.size.height - 55, width: 100, height: 50))
        button.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        button.setTitle("Log out", for: .normal)
        button.addTarget(self, action: #selector(MapHomeViewController.sendLocAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(section == 0){
            return "Friend Requests";
        }
        else if(section == 1){
            return "Friends";
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
        return 2;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return requests.count;
        }
        else if (section == 1){
            return locs.count;
        }
        else{
            return 0;
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locCell", for: indexPath)

        // Configure the cell...
        if(indexPath.section == 0){
            cell.textLabel!.text = self.requests[indexPath.row].name;
        }
        else if(indexPath.section == 1){
            cell.textLabel!.text = self.locs[indexPath.row].name + ": (" + self.locs[indexPath.row].lat + ", " + self.locs[indexPath.row].lng + ")"
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
   //     var myVC = storyboard?.instantiateViewController(withIdentifier: "MapHomeViewController") as! MapHomeViewController
        
        
        if(indexPath.section == 0){
            ref.child("friends").child(FIRAuth.auth()?.currentUser?.uid as String!).child(requests[indexPath.row].id).setValue(1);
            ref.child("friends").child(requests[indexPath.row].id).child(FIRAuth.auth()?.currentUser?.uid as String!).setValue(1);
            requests.remove(at: indexPath.row);
        }
        //Friend is clicked
        if(indexPath.section == 1){
            self.passLat = Double(self.locs[indexPath.row].lat)!
            self.passLong = Double(self.locs[indexPath.row].lng)!
            self.passName = self.locs[indexPath.row].name
            
            self.performSegue(withIdentifier: "tableToMapSegue", sender: self)
        }
        
    }
    
    func goHome() {
        self.performSegue(withIdentifier: "returnToHomeSegue", sender: self)
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
      /*  let destinationVC = segue.destination as? ViewController

        try! FIRAuth.auth()?.signOut()
        
        destinationVC?.UsernameLabel.text = ""
        destinationVC?.logoutButton.alpha = 0.0
        destinationVC?.emailField.text = ""
        destinationVC?.passwordField.text = ""
        destinationVC?.emailField.alpha = 1.0
        destinationVC?.passwordField.alpha = 1.0
        destinationVC?.loginButton.alpha = 1.0
        destinationVC?.accountButton.alpha = 1.0*/
        
        let destinationVC = segue.destination as? MapHomeViewController
        destinationVC?.latPassed=self.passLat
        destinationVC?.lngPassed=self.passLong
        destinationVC?.namePassed=self.passName
    }
    
    func goToSettings(){
        self.performSegue(withIdentifier: "FriendstoSettingsSegue", sender: self)
    }

}
