//
//  FirstScreen.swift
//  BLEDemo
//
//  Created by Duaa alharbi 1607217 - Doaa altawil 0932785
//  2020

import UIKit
import Firebase

class FirstScreen: UIViewController {

    
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //functhion viewDidLoad to view has been loaded into memory
        
     if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "toTheMain", sender: self)
     //currentUser represents if that participant is the owner of this account
            
       }

        // Do any additional setup after loading the view.
    }
    

}
