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

class LocationTableViewController: UITableViewController {
    var  locs = [String]()
    let ref = FIRDatabase.database().reference(withPath: "data")
    var newLocs = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newLocs = []
        ref.child("locations").observe(FIRDataEventType.value, with: { (snapshot) in
            print(snapshot.value)
            let dict = snapshot.value as? [String : [String : Double]] ?? [:]
            for (key, value) in dict {
                print(key)
       //         self.newLocs.append((value["lng"] as! String));
            }
            self.locs = self.newLocs;
            self.tableView.reloadData();
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locCell", for: indexPath)

        // Configure the cell...
        cell.textLabel!.text = self.locs[indexPath.row]
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
