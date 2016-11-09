//
//  AccountCreationViewController.swift
//  firebaseTest
//
//  Created by SE Group 1 on 11/8/16.
//  Copyright © 2016 SEGroup1. All rights reserved.
//

import UIKit
import Firebase

class AccountCreationViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmEmailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    

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
    @IBAction func createAccountAction(_ sender: AnyObject) {
        if self.emailField.text == "" || self.passwordField.text == ""
        {
            let alertController = UIAlertController(title: "Oops", message: "Please enter an email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.emailField.text != self.confirmEmailField.text
        {
            let alertController = UIAlertController(title: "Oops", message: "Your email fields did not match", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            self.emailField.text = ""
            self.confirmEmailField.text = ""
        }
        else if self.passwordField.text != self.confirmPasswordField.text
        {
            let alertController = UIAlertController(title: "Oops", message: "Your password fields did not match", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            self.passwordField.text = ""
            self.confirmPasswordField.text = ""
        }
        else
        {
            FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if error == nil
                {
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.confirmPasswordField.text = ""
                    self.confirmEmailField.text = ""
                    let alertController = UIAlertController(title: "Success", message: "Account Created", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    //self.present(alertController, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "creationToLoginSegue", sender: self)
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
    
    

}
