//
//  EntryViewController.swift
//  Homework_1
//
//  Created by Maksim on 26.05.2021.
//

import UIKit
import Foundation
import RxSwift

class EntryViewController: UIViewController {

    @IBOutlet weak var appNameLbl: UILabel!
    
    let disposeBag = DisposeBag()
    let publishSubject = PublishSubject<UIColor>()
    var appNameTextColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToColorOfAppNameLbl()
        setupView()
        addTapToAppNameLbl()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        publishSubject.dispose()
    }
    
    //MARK: -> Настройка цвета и интерактивности appNameLbl
    func subscribeToColorOfAppNameLbl(){
        publishSubject.subscribe { (color) in
             print("label Color is: ", color.element )
             self.appNameLbl.textColor = color.element
         }.disposed(by: disposeBag)
    }
    
    func setupView() {
        changeAppNameTextColor()
    }
    
    func changeAppNameTextColor() {
        let randomRedColor =  Double.random(in: 0...1)
        let randomGreenColor =  Double.random(in: 0...1)
        let randomBlueColor =  Double.random(in: 0...1)
        let newColor = UIColor(red: CGFloat(randomRedColor), green: CGFloat(randomGreenColor), blue: CGFloat(randomBlueColor), alpha: 1)
        publishSubject.onNext(newColor)
        }
    
    func addTapToAppNameLbl(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAppNameLbl(_:)))
        self.appNameLbl.isUserInteractionEnabled = true
        self.appNameLbl.addGestureRecognizer(tap)
    }
    
    @objc func tapAppNameLbl(_ sender: UITapGestureRecognizer){
        print("tapped")
        self.changeAppNameTextColor()
    }

    //MARK: ->Кнопки Login
    @IBAction func loginToGoogleBtnWasPrssd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "loginToFirebaseViewController")
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func skipGoogleLoginBtnWasPrssd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "vkLogin")
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true, completion: nil)
    }
}
