//
//  LoadingAnimation.swift
//  Homework_1
//
//  Created by Maksim on 01.07.2021.
//

import UIKit

class LoadingAnimationView: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            //fatalError("init(coder:) has not been implemented")
        }
    
    func setRandomColor() -> UIColor {
        let randomRedColor =  Double.random(in: 0...1)
        let randomGreenColor =  Double.random(in: 0...1)
        let randomBlueColor =  Double.random(in: 0...1)
        return UIColor(red: CGFloat(randomRedColor), green: CGFloat(randomGreenColor), blue: CGFloat(randomBlueColor), alpha: 1)
        }
        
        override func draw(_ rect: CGRect) {
            let cloudLayer = CAShapeLayer()
            cloudLayer.fillColor = setRandomColor().cgColor
            let cloudPath = UIBezierPath()
            cloudPath.move(to: CGPoint(x: 7.53, y: 25.5))
            cloudPath.addCurve(to: CGPoint(x: 20, y: 25.5),
                               controlPoint1: CGPoint(x: 15, y: 30),
                               controlPoint2: CGPoint(x: 25, y: 30))
            cloudPath.addCurve(to: CGPoint(x: 30, y: 25.5),
                               controlPoint1: CGPoint(x: 25, y: 30),
                               controlPoint2: CGPoint(x: 35, y: 30))
            cloudPath.addCurve(to: CGPoint(x: 40, y: 25.5),
                               controlPoint1: CGPoint(x: 35, y: 30),
                               controlPoint2: CGPoint(x: 45, y: 30))
            
            cloudPath.addCurve(to: CGPoint(x: 39.44, y: 11.5),
                               controlPoint1: CGPoint(x: 50.23, y: 25.5),
                               controlPoint2: CGPoint(x: 49.67, y: 11.61))
            cloudPath.addCurve(to: CGPoint(x: 22.27, y: 7.64),
                               controlPoint1: CGPoint(x: 42.21, y: 2.34),
                               controlPoint2: CGPoint(x: 25.38, y: -1.3))
            cloudPath.addCurve(to: CGPoint(x: 10.13, y: 13.37),
                               controlPoint1: CGPoint(x: 17.19, y: 4.44),
                               controlPoint2: CGPoint(x: 10.86, y: 8.35))
            cloudPath.addCurve(to: CGPoint(x: 7.53, y: 25.5),
                               controlPoint1: CGPoint(x: 0.53, y: 12.87),
                               controlPoint2: CGPoint(x: -0.1, y: 25.11))
            cloudPath.close()
            cloudLayer.path = cloudPath.cgPath
            cloudLayer.strokeColor = setRandomColor().cgColor
            cloudLayer.lineWidth = 2.0
            cloudLayer.lineCap = .round
            cloudLayer.transform = CATransform3DMakeScale(4, 4, 1)
            cloudLayer.frame.origin = CGPoint(x: self.frame.width/4, y: self.frame.height/4)
            self.layer.addSublayer(cloudLayer)

            let snakeLayer = CAShapeLayer()
            snakeLayer.backgroundColor = UIColor.red.cgColor
            snakeLayer.bounds = CGRect(x: 0, y: 0, width: 10, height: 2)
            snakeLayer.position = CGPoint(x: 10, y: 10)
            snakeLayer.path = cloudPath.cgPath
            snakeLayer.cornerRadius = 2
    
            let followPathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
            followPathAnimationStart.fromValue = 0
            followPathAnimationStart.toValue = 1
            
            let followPathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
            followPathAnimationEnd.fromValue = 0.05
            followPathAnimationEnd.toValue = 1.05
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 8
            animationGroup.repeatCount = .infinity
            animationGroup.animations = [followPathAnimationStart,followPathAnimationEnd]
            
            cloudLayer.add(animationGroup, forKey: nil)
        }
}

