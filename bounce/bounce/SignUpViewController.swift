//
//  SignUpViewController.swift
//  bounce
//
//  Created by Derin Serbetcioglu on 11/24/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePasswordField: UITextField!

    @IBOutlet weak var CreateAccountStatusTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Shake screen function
    func shake() {
        self.emailField.transform = CGAffineTransform(translationX: 12, y: 0)
        self.passwordField.transform = CGAffineTransform(translationX: 12, y: 0)
        self.rePasswordField.transform = CGAffineTransform(translationX: 12, y: 0)
        self.CreateAccountStatusTextView.transform = CGAffineTransform(translationX: 12, y: 0)
        self.cancelButton.transform = CGAffineTransform(translationX: 12, y: 0)
        self.createAccountButton.transform = CGAffineTransform(translationX: 12, y: 0)
        
        UIView.animate(withDuration: 0.5 , delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.emailField.transform = CGAffineTransform.identity
            self.passwordField.transform = CGAffineTransform.identity
            self.rePasswordField.transform = CGAffineTransform.identity
            self.CreateAccountStatusTextView.transform = CGAffineTransform.identity
            self.cancelButton.transform = CGAffineTransform.identity
            self.createAccountButton.transform = CGAffineTransform.identity
            
        }, completion: nil)
    }
    

    @IBAction func createAccountClicked(_ sender: Any) {
        // If both password fields don't match, shake screen and present error
        if (self.passwordField.text != self.rePasswordField.text){
            self.passwordField.text = ""
            self.rePasswordField.text = ""
            self.CreateAccountStatusTextView.text = "Password confirmation does not match"
            self.shake()
        }
        else{
            // Otherwise, create account and print error if necessary
            // Then segue back to login
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!){ (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "accountSuccessfullyCreated", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
        }
        
        
    }
    
   
 
    
    }
}
