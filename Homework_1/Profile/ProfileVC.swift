//
//  ProfileVC.swift
//  Homework_1
//
//  Created by Maksim on 25.02.2021.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var logOutFromFirebaseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    
    
    
    @IBAction func logOutFromFirebaseButtonWasPressed(_ sender: Any) {
        
        do {
        try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error)
        {
        print("Auth sign out failed: \(error)")
            
        }
    }
    
    
}
