//
//  PreLoginVC.swift
//  Homework_1
//
//  Created by Maksim on 20.03.2021.
//

import UIKit
import Foundation

class PreLoginVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
//            self.goToLoginVC()
//                UIView.animate(withDuration: 0.9) {
//                    self.view.alpha = 0.2
//            }
//        }
        
        
        
        
    }
    
    func setupView(){
        
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        createCloudLayer()
//    }
    
//    override func layoutSubviews() {
//            super.layoutSubviews()
//        createCloudLayer()
//    }
    
    func createCloudLayer(){
        print("\n метод работает!")
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        let width: CGFloat = 200
//        let height: CGFloat = 200
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.frame = CGRect(x: 40, y: 40, width: width, height: height)
//
//        let path = CGMutablePath()
//
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: myView.bounds.size.width / 2, y: 0), radius: myView.bounds.size.height, startAngle: 0.0, endAngle: .pi, clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = UIColor.red.cgColor
        myView.layer.mask = circleShape
        
        view.addSubview(myView)
        
    }
    
    func goToLoginVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "loginVC")
        view.modalPresentationStyle = .fullScreen
        //view.modalTransitionStyle = .partialCurl
        present(view, animated: true, completion: nil)
    }
}




//func setupView(){
//
//        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
//
//        let viewRect1 = UIView(frame: rect)
//        viewRect1.backgroundColor = .black
//        viewRect1.layer.cornerRadius = viewRect1.frame.height/2
//
//        let viewRect2 = UIView(frame: rect)
//        viewRect2.backgroundColor = .black
//        viewRect2.layer.cornerRadius = viewRect1.frame.height/2
//
//        let viewRect3 = UIView(frame: rect)
//        viewRect3.backgroundColor = .black
//        viewRect3.layer.cornerRadius = viewRect1.frame.height/2
//
//        self.view.addSubview(viewRect1)
//        self.view.addSubview(viewRect2)
//        self.view.addSubview(viewRect3)
//
//        UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
//            viewRect1.frame.origin.x += 150
//            viewRect1.frame.origin.y += 250
//        })
//
//        UIView.animate(withDuration: 0.5, delay: 0.8, animations: {
//            viewRect2.frame.origin.x += 180
//            viewRect2.frame.origin.y += 250
//        })
//
//        UIView.animate(withDuration: 0.5, delay: 1.1, animations: {
//            viewRect3.frame.origin.x += 210
//            viewRect3.frame.origin.y += 250
//        })
//
//        UIView.animate(withDuration: 0.4, delay: 1.5, options: [.repeat, .autoreverse], animations: {
//            viewRect1.alpha = 0.2
//        })
//        UIView.animate(withDuration: 0.4, delay: 1.7, options: [.repeat, .autoreverse], animations: {
//            viewRect2.alpha = 0.2
//        })
//        UIView.animate(withDuration: 0.4, delay: 1.9, options: [.repeat, .autoreverse], animations: {
//            viewRect3.alpha = 0.2
//        })
//    }
