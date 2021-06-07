//
//  ProfileViewController.swift
//  Homework_1
//
//  Created by Maksim on 26.05.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var logoutFromFirebaseBtn: UIButton!
    
    private let apiVkServices = ApiVkServices()
    private var handle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("Пользователь Firebase обнаружен. Аутентификация не требуется.")
                self.logoutFromFirebaseBtn.setTitle("Log out from Google(Firebase)", for: .normal)
            } else {
                print("Пользователь Firebase не обнаружен. Требуется аутентификация.")
                self.logoutFromFirebaseBtn.setTitle("Log in to Google(Firebase)", for: .normal)
                self.logoutFromFirebaseBtn.backgroundColor = .green
            }
        }
    }
    

    @IBAction func logoutFromFirebaseBtnWasPrssd(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error)
        {
            print("Auth sign out failed: \(error)")
        }
    }
    
    @IBAction func logoutFromVkServerBtnWasPrssd(_ sender: Any) {
        apiVkServices.logOutFromVkServer()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "vkLogin")
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true, completion: nil)
    }
    
}






    

