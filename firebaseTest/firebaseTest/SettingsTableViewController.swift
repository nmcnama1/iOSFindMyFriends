//
//  SettingsTableViewController.swift
//  firebaseTest
//
//  Created by Nancy Ann on 12/11/16.
//  Copyright © 2016 SEGroup1. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class SettingsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var Killswitch: UISwitch!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var IntervalText: UILabel!
    @IBOutlet weak var AutoUpdateSwitch: UISwitch!
    
    let ref = FIRDatabase.database().reference(withPath: "data")
    
    var pickerDataSource = ["1 minute", "5 minutes", "10 minutes"];
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var cameFrom = "Map"
    var invalidPickerAccess=0
    var limit = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        self.invalidPickerAccess=0
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        Killswitch.setOn(appDelegate.sharing, animated: false)
        if(appDelegate.interval==0) {
            AutoUpdateSwitch.setOn(false, animated: false)
            self.limit=5
        } else {
            AutoUpdateSwitch.setOn(true, animated: false)
            if (appDelegate.interval==1) {
                pickerView.selectRow(0, inComponent: 0, animated: false)
            } else if (appDelegate.interval==5) {
                pickerView.selectRow(1, inComponent: 0, animated: false)
            } else if (appDelegate.interval==10) {
                pickerView.selectRow(2, inComponent: 0, animated: false)
            }
            self.limit=7
        }
       // AutoUpdateSwitch.setOn(true, animated: true)
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
       // Killswitch.isOn =  UserDefaults.standard.bool(forKey: "switchState")
        if(cameFrom=="Map") {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(SettingsTableViewController.reloadMap))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section==0) {
            return 4
        } else {
            return 2
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if (indexPath==[0,0]) {                     //enable location sharing
            Killswitch.setOn(!Killswitch.isOn, animated: true)
            self.killswitchFlip(Killswitch)
        } else if (indexPath==[0,1]) {              //enable auto update
            AutoUpdateSwitch.setOn(!AutoUpdateSwitch.isOn, animated: true)
            self.AutoUpdateChange(AutoUpdateSwitch)
        } else if (indexPath==[1,0]) {             //account details
            self.performSegue(withIdentifier: "SettingsToAccountSegue", sender: self)
        } else if (indexPath==[1,1]) {              //logout
            self.confirmLogout()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath==[0,1]) {
            if (!Killswitch.isOn) {
                return 0.0
            }
        } else if (indexPath==[0,2]) {
            if (!AutoUpdateSwitch.isOn || !Killswitch.isOn) {
                return 0.0
            }
        } else if (indexPath==[0,3]) {
            if (!AutoUpdateSwitch.isOn || !Killswitch.isOn) {
                return 0.0
            } else {
                return 165.0
            }
        }
        return 44.0
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func AutoUpdateChange(_ sender: AnyObject) {
        if(!AutoUpdateSwitch.isOn) {
            appDelegate.interval=0
            SharingManager.sharedInstance.stopTimer()
        } else {
            let currentPicked = pickerView.selectedRow(inComponent: 0)
            if (currentPicked==0) {
                appDelegate.interval=1
                SharingManager.sharedInstance.stopTimer()
                SharingManager.sharedInstance.startTimer(interval: 60)
            } else if (currentPicked==1) {
                appDelegate.interval=5
                SharingManager.sharedInstance.stopTimer()
                SharingManager.sharedInstance.startTimer(interval: 300)
            } else if (currentPicked==2) {
                appDelegate.interval=10
                SharingManager.sharedInstance.stopTimer()
                SharingManager.sharedInstance.startTimer(interval: 600)
            }
        }
        tableView.reloadData()
    }
    
    ////////////////////// Methods to make SettingsTableViewController the UIPicker Delegate
    //number of columns in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of possible items in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    //handles selection
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(self.invalidPickerAccess)
        if (self.invalidPickerAccess>self.limit) {
            if (row==0) {
                appDelegate.interval=1
                SharingManager.sharedInstance.stopTimer()
                SharingManager.sharedInstance.startTimer(interval: 60)
            } else if (row==1) {
                appDelegate.interval=5
                SharingManager.sharedInstance.stopTimer()
                SharingManager.sharedInstance.startTimer(interval: 300)
            } else if (row==2) {
                appDelegate.interval=10
                SharingManager.sharedInstance.stopTimer()
                SharingManager.sharedInstance.startTimer(interval: 600)
            }
            IntervalText.text = pickerDataSource[row]
            if(!AutoUpdateSwitch.isOn || !Killswitch.isOn) {
                SharingManager.sharedInstance.stopTimer()
                appDelegate.interval=0
        }
        }
        self.invalidPickerAccess += 1
        return pickerDataSource[row]
    }
    ///////////////////////
    
    @IBAction func killswitchFlip(_ sender: AnyObject) {
        UserDefaults.standard.set(Killswitch.isOn, forKey: "switchState")
        tableView.reloadData()
        if(!Killswitch.isOn) {
            //Kill my location
            appDelegate.sharing=false;
            SharingManager.sharedInstance.stopTimer()
            self.ref.child("locations").child(FIRAuth.auth()?.currentUser?.uid as String!).removeValue()
        } else {//return my location
            //We need to re-get the user's location, and I think the location manager needs to not just be defined in the maphomeviewcontroller
            SharingManager.sharedInstance.sendLocationTimed()
            appDelegate.sharing=true;
        }
    }
    @IBAction func confirmLogout() {
        
        // create the alert
        let alert = UIAlertController(title: "Confirm Logout", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: logoutAction))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func logoutAction(alert: UIAlertAction!) {
        
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "LogoutSegue", sender: self)
    }
    
    func sendLocation() {
        let user = FIRAuth.auth()?.currentUser
        var name=""
        ref.child("users").child((user?.uid)!).observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            name=dict["name"] as! String
            self.ref.child("locations").child((user?.uid)!).setValue(["lat": "-40.1", "lng":"100.5", "name": name])
        })
    }
    
    func reloadMap() {
        self.performSegue(withIdentifier: "BackSegue", sender: self)
    }


}
