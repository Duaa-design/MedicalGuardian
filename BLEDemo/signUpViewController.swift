//
//  signUpViewController.swift
//  BLEDemo
//
//  Created by Duaa alharbi 1607217 - Doaa altawil 0932785
//

import UIKit
import Firebase
import SVProgressHUD


class signUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
   
    @IBAction func textlable(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //functhion viewDidLoad to view has been loaded into memory
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        //to show Progress Indicators , we use progress indicators to let people know the app hasn't stalled
        
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            //Set up a new user on our Firebase database ,Create a form that allows new users to register with app using createUser method
            
            
            if error != nil {
                print(error!)
                SVProgressHUD.dismiss()
                
                let alertVC = UIAlertController(title: "Error", message: "The Email you entered already exist", preferredStyle: .alert)
                //display an alert message to the user
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    alertVC.dismiss(animated: true, completion: nil)
                })
                //An action that can be taken when the user taps a button in an alert.
                
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
                
                
            } else {
                print("Registration Successful!")
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "toTheMain", sender: self)
                //Performs to the specified segue.
            }
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //function to representing the location, size, movement, and force of a touch occurring on the screen.
        self.view.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //function to Ask the delegate whether to process the pressing of the Return button for the text field.
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return(true)
        //Notifies this object that it has been asked to relinquish its status as first responder in its window.
    }
    
}
