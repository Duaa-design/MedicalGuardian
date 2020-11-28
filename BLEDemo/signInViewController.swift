//
//  signInViewController.swift
//  BLEDemo
//
//  Created by Duaa alharbi 1607217 - Doaa altawil 0932785
//

import UIKit
import Firebase
import SVProgressHUD


class signInViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //functhion viewDidLoad to view has been loaded
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        //The delegate to manage the editing and validation of text in a text field object.
        
        //Do any additional setup after loading the view.
    }
    
    
    @IBAction func signInPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        //to show Progress Indicators , we use progress indicators to let people know the app hasn't stalled
        
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            //Create a form that allows existing users to sign in using signIn method
            
            if error != nil {
                print(error!)
                SVProgressHUD.dismiss()
                
                let alertVC = UIAlertController(title: "Error", message: "Check your Email/Password", preferredStyle: .alert)
                //display an alert message to the user
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    alertVC.dismiss(animated: true, completion: nil)
                })
                //An action that can be taken when the user taps a button in an alert.
                
                alertVC.addAction(okAction)
                
                self.present(alertVC, animated: true, completion: nil)
                
                
            } else {
                print("Log in successful!")
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "toTheMain", sender: self)
                //Performs to the specified segue to main page.
                
            }
            
        }

        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
       
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //function to Ask the delegate whether to process the pressing of the Return button for the text field.
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return(true)
        
    }
    

}

