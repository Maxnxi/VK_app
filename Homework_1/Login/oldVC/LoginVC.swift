//
//  LoginVC.swift
//  Homework_1
//
//  Created by Maksim on 16.02.2021.
//

import UIKit
import Foundation

class LoginVC: UIViewController {

    
    
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var psswdLbl: UILabel!
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTxtField: UITextField!
    @IBOutlet weak var psswdTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    //  дополнение - апгрейд стиля
    var placeholderLogin = NSAttributedString(string: "Введите Логин (123)", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), NSAttributedString.Key.font:UIFont(name: "Menlo", size: 20.0)!])
    var placeholderPassword = NSAttributedString(string: "Введите Пароль (123)", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), NSAttributedString.Key.font:UIFont(name: "Menlo", size: 20.0)!])
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Временно остановлено
        loadingScreenView()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
                        UIView.animate(withDuration: 0.9) {
                            self.loadingView.alpha = 0
                        } completion: { (finished) in
                            self.loadingView.isHidden = true
                        }
            print("Loading completed")
                }
        
        //  дополнение - апгрейд стиля
        loginLbl.isHidden = true
        psswdLbl.isHidden = true
        
        
        loginTxtField.clearsOnBeginEditing = true
        psswdTxtField.clearsOnBeginEditing = true
       
        btnDisable()
        loginTxtField.attributedPlaceholder = placeholderLogin
        loginTxtField.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        psswdTxtField.attributedPlaceholder = placeholderPassword
        psswdTxtField.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
            psswdTxtField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        //
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBordWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    @IBAction func loginBtnWasPrssd(_ sender: Any) {
        if loginTxtField.text == "123" && psswdTxtField.text == "123" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "afterLoginTabBarVC")
            view.modalPresentationStyle = .fullScreen
            present(view, animated: true, completion: nil)
            print("You are Logged in.")
        } else {
            showAlertView()
        }
        
        
        
    }
}
extension LoginVC {
    //  дополнение - апгрейд стиля
    @objc func textFieldDidChange(){
        if psswdTxtField.text == "" {
            btnDisable()
        } else {
            btnEnabled()
        }
    }
    
    func btnDisable(){
        loginBtn.isEnabled = false
        loginBtn.backgroundColor = #colorLiteral(red: 0.258797586, green: 0.2588401437, blue: 0.2587882876, alpha: 1)
        loginBtn.setTitleColor(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), for: .normal)
        loginBtn.alpha = 0.5
    }
    
    func btnEnabled(){
        loginBtn.isEnabled = true
        loginBtn.backgroundColor = #colorLiteral(red: 0.258797586, green: 0.2588401437, blue: 0.2587882876, alpha: 1)
        loginBtn.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: .normal)
        loginBtn.alpha = 1
    }
    //
    
}

 // MARK ->
extension LoginVC {
    
    func showAlertView(){
        let alert = UIAlertController(title: "Ошибка", message: "введен не правильный пароль", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK -> keyboard hide/show
extension LoginVC {
    @objc func keyBordWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
}

extension LoginVC {
    
    @IBAction func unWindToLogin(_ segue: UIStoryboardSegue){
        
        loginTxtField.text = ""
        psswdTxtField.text = ""
        
    }
}


//MARK: -> LOADING VIEW

extension LoginVC {
    
    func loadingScreenView(){
        loadingView.isHidden = false
        loadingView.backgroundColor = .white
        loadingView.alpha = 1

    }
}
