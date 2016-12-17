//
//  ViewController.swift
//  firebaseTest
//
//  Created by SE Group 1 on 11/2/16.
//  Copyright © 2016 SEGroup1. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ViewController: UIViewController {

    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let ref = FIRDatabase.database().reference(withPath: "data")
    override func viewDidLoad() {
        super.viewDidLoad()
  //      navigationController?.setNavigationBarHidden(false, animated: true)
        if let user = FIRAuth.auth()?.currentUser
        {
            self.getSharing()
            self.UsernameLabel.text = user.email
            self.emailField.alpha = 0.0
            self.passwordField.alpha = 0.0
            self.loginButton.alpha = 0.0
            self.accountButton.alpha = 0.0
            self.performSegue(withIdentifier: "SuccessfulLoginSegue", sender: self)
        }
        else
        {
            self.UsernameLabel.text = ""
        }
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //THIS IS ACTUALLY LOGIN CODE: I made a mistake when making connections to story board and am too afraid to try and change names
    @IBAction func createAccountAction(_ sender: AnyObject) {
        
        if self.emailField.text == "" || self.passwordField.text == ""
        {
            let alertController = UIAlertController(title: "Oops", message: "Please enter an email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if error == nil
                {
                    self.getSharing()
                    
                    self.UsernameLabel.text = user!.email
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    
                    self.emailField.alpha = 0.0
                    self.passwordField.alpha = 0.0
                    self.loginButton.alpha = 0.0
                    self.accountButton.alpha = 0.0
                    self.performSegue(withIdentifier: "SuccessfulLoginSegue", sender: self)
                }
                else
                {
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        
    }
    

    
    //determines whether location sharing should be turned on based on whether a location is in the DB
    func getSharing() {
        ref.child("locations").child(FIRAuth.auth()?.currentUser?.uid as String!).observeSingleEvent(of:FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            if (dict.count==0) {
                self.appDelegate.sharing=false
            } else {
                self.appDelegate.sharing=true
            }
        })
    }
}

