//
//  LoginToFirebaseViewController.swift
//  Homework_1
//
//  Created by Maksim on 14.05.2021.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
//import FirebaseDatabase

class LoginToFirebaseViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("Пользователь Firebase обнаружен. Аутентификация не ребуется.")
                self.moveToVkLoginViewController()
            }
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    func setupView(){
        
    }
    
    func moveToVkLoginViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "vkLogin")
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonWasPressed(_ sender: Any) {
        guard let email = emailTxtField.text,
              let password = passwordTxtField.text else {
            print("no email or password")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if let error = error {
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] (usr, err) in
                    if let err = err {
                        print("Error while creating user")
                        let alert = UIAlertController(title: "Error while creating user", message:
                                                        error.localizedDescription, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .cancel)
                        alert.addAction(okAction)
                        self?.present(alert, animated: true, completion: nil)
                    }
                    if let usr = usr {
                        print("User created successfuyly.")
                        Auth.auth().signIn(withEmail: email, password: password)
                        self?.moveToVkLoginViewController()
                    }
                    
                }
            }
            if let user = user {
                print("User found. Log in success.")
                self?.moveToVkLoginViewController()
            }
        }
        
        
        
        
    }
    
    @IBAction func backBtnWasPrssd(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipLoginButton(_ sender: Any) {
       moveToVkLoginViewController()
    }
    

}
