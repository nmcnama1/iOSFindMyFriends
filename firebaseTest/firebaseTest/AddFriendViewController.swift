//
//  AddFriendViewController.swift
//  firebaseTest
//
//  Created by SE Group 1 on 12/14/16.
//  Copyright © 2016 SEGroup1. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class AddFriendViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var requestAction: UIButton!
    let ref = FIRDatabase.database().reference(withPath: "data");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sendRequestAction(_ sender: Any) {
        ref.child("users").queryOrdered(byChild: "email").queryEqual(toValue: self.emailTextField.text!).observeSingleEvent(of: .childAdded, with: {snapshot in
                let friendID = snapshot.key;
            self.ref.child("friends").child(friendID).child(FIRAuth.auth()?.currentUser?.uid as String!).setValue(2);
            self.emailTextField.text = "Request Sent!"
        })
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }

}
