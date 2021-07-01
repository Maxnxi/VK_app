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
    
    private let disposeBag = DisposeBag()
    private let publishSubject = PublishSubject<UIColor>()
    private var appNameTextColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToColorOfAppNameLbl()
        setupView()
        addTapToAppNameLbl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //startDotsAnimation(time: 6) //animation
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        publishSubject.dispose()
    }
    
    //MARK: -> Настройка цвета и интерактивности appNameLbl
    func subscribeToColorOfAppNameLbl(){
        publishSubject.subscribe { (color) in
            print("label Color is: ", color.element ?? 0 )
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


//MARK: -> animation
extension EntryViewController {
    func startDotsAnimation(time: Int) {
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.addSubview(coverView)
        coverView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        coverView.alpha = 0.7
        UIView.startLoadingFirstEntryAnimation(view: coverView, time: time)
    }
}
