//
//  ViewController.swift
//  bounce
//
//  Created by Derin Serbetcioglu on 11/13/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

/*
 To-do:
 
 
 */
import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginStatusTextView: UITextView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Shake screen function
    func shake() {
        self.emailField.transform = CGAffineTransform(translationX: 12, y: 0)
        self.passwordField.transform = CGAffineTransform(translationX: 12, y: 0)
        self.loginStatusTextView.transform = CGAffineTransform(translationX: 12, y: 0)
        self.loginButton.transform = CGAffineTransform(translationX: 12, y: 0)
        self.createAccountButton.transform = CGAffineTransform(translationX: 12, y: 0)
        UIView.animate(withDuration: 0.5 , delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.emailField.transform = CGAffineTransform.identity
            self.passwordField.transform = CGAffineTransform.identity
            self.loginStatusTextView.transform = CGAffineTransform.identity
            self.loginButton.transform = CGAffineTransform.identity
            self.createAccountButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // Login function that segues to the main page
    @IBAction func login(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
               // If login info is incorrect, shake screen & present error
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.loginStatusTextView.text = "Login information incorrect"
                    self.passwordField.text = ""
                    self.shake()
                    return
                }
                // Otherwise perform the segue to main page
                self.performSegue(withIdentifier: "segueFromLogin", sender: self.loginButton)
            }
         }
        
    }
  
                    
    // Do nothing & unwind if you click cancel from the signup VC
    @IBAction func unwindCancelAccountCreation(segue: UIStoryboardSegue){
    }

}
