//
//  FriendOptionsViewController.swift
//  firebaseTest
//
//  Created by SE Group 1 on 12/13/16.
//  Copyright © 2016 SEGroup1. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FriendOptionsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var latPassed = 40.759211
    var lngPassed = -73.984638
    var passedID = "0101010";
    var namePassed = "test"
    let ref = FIRDatabase.database().reference(withPath: "data");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = self.namePassed;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteFriendAction(_ sender: Any) {
        ref.child("friends").child(FIRAuth.auth()?.currentUser?.uid as String!).child(self.passedID).removeValue();
        ref.child("friends").child(self.passedID).child(FIRAuth.auth()?.currentUser?.uid as String!).removeValue();
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func findFriendAction(_ sender: Any) {
        self.performSegue(withIdentifier: "friendOptToMapSeque", sender: self);
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "friendOptToMapSeque"){
            let vc = segue.destination as! MapHomeViewController;
        
            vc.latPassed=self.latPassed;
            vc.lngPassed=self.lngPassed;
            vc.namePassed=self.namePassed;
        }
        
    }
    

}
