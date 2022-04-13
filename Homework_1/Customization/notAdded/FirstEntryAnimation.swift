//
//  FirstEntryAnimation.swift
//  Homework_1
//
//  Created by Maksim on 01.07.2021.
//

import UIKit

class FirstEntryAnimationView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 800))

        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)

        let viewRect1 = UIView(frame: rect)
        viewRect1.backgroundColor = UIColor.randomClr
            //setRandomColor()
        viewRect1.layer.cornerRadius = viewRect1.frame.height/2

        let viewRect2 = UIView(frame: rect)
        viewRect2.backgroundColor = UIColor.randomClr
        //setRandomColor()
        viewRect2.layer.cornerRadius = viewRect1.frame.height/2

        let viewRect3 = UIView(frame: rect)
        viewRect3.backgroundColor = UIColor.randomClr
        //setRandomColor()
        viewRect3.layer.cornerRadius = viewRect1.frame.height/2

        view.addSubview(viewRect1)
        view.addSubview(viewRect2)
        view.addSubview(viewRect3)

        UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
            viewRect1.frame.origin.x += 150
            viewRect1.frame.origin.y += 250
        })

        UIView.animate(withDuration: 0.5, delay: 0.8, animations: {
            viewRect2.frame.origin.x += 180
            viewRect2.frame.origin.y += 250
        })

        UIView.animate(withDuration: 0.5, delay: 1.1, animations: {
            viewRect3.frame.origin.x += 210
            viewRect3.frame.origin.y += 250
        })

        UIView.animate(withDuration: 0.4, delay: 1.5, options: [.repeat, .autoreverse], animations: {
            viewRect1.alpha = 0.2
        })
        UIView.animate(withDuration: 0.4, delay: 1.7, options: [.repeat, .autoreverse], animations: {
            viewRect2.alpha = 0.2
        })
        UIView.animate(withDuration: 0.4, delay: 1.9, options: [.repeat, .autoreverse], animations: {
            viewRect3.alpha = 0.2
        })
    }

    //random color
//    func setRandomColor() -> UIColor {
//        let randomRedColor =  Double.random(in: 0...1)
//        let randomGreenColor =  Double.random(in: 0...1)
//        let randomBlueColor =  Double.random(in: 0...1)
//        return UIColor(red: CGFloat(randomRedColor), green: CGFloat(randomGreenColor), blue: CGFloat(randomBlueColor), alpha: 1)
//        }
}
