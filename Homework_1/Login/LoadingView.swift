//
//  LoadingView.swift
//  Homework_1
//
//  Created by Maksim on 01.04.2021.
//

import UIKit
import Foundation

class LoadingView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
//        guard let context = UIGraphicsGetCurrentContext() else {return}
//        context.setStrokeColor(UIColor.white.cgColor)
        
        let cloudLayer = CAShapeLayer()
        
        //cloudLayer.borderColor = UIColor.red.cgColor
        cloudLayer.fillColor = UIColor.blue.cgColor
        let cloudPath = UIBezierPath()
        cloudPath.move(to: CGPoint(x: 7.53, y: 25.5))
        //cloudPath.addLine(to: CGPoint(x: 40.74, y: 25.5))
        
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
        cloudLayer.strokeColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor
        //cloudLayer.
        cloudLayer.lineWidth = 2.0
        cloudLayer.lineCap = .round
        //cloudLayer.lineDashPattern = [8,6]
        cloudLayer.transform = CATransform3DMakeScale(4, 4, 1)
        cloudLayer.frame.origin = CGPoint(x: self.frame.width/4, y: self.frame.height/4)
        self.layer.addSublayer(cloudLayer)

        
        // test circle
//        let circleLayer = CAShapeLayer()
//        circleLayer.backgroundColor = UIColor.red.cgColor
//        circleLayer.bounds = CGRect(x: 0, y: 0, width: 4, height: 4)
//        circleLayer.position = CGPoint(x: 10, y: 10)
//        circleLayer.cornerRadius = 2
        
        // let followPathAnimation = CAKeyframeAnimation(keyPath: "position")
        
//        followPathAnimation.path = cloudPath.cgPath
//        followPathAnimation.calculationMode = .paced
//        followPathAnimation.speed = 0.1
//        followPathAnimation.repeatCount = .infinity
        
        //circleLayer.add(followPathAnimation, forKey: nil)
        //cloudLayer.addSublayer(circleLayer)
        
        // snake layer
        let snakeLayer = CAShapeLayer()
        snakeLayer.backgroundColor = UIColor.red.cgColor
        snakeLayer.bounds = CGRect(x: 0, y: 0, width: 10, height: 2)
        snakeLayer.position = CGPoint(x: 10, y: 10)
        snakeLayer.path = cloudPath.cgPath
        snakeLayer.cornerRadius = 2
//        snakeLayer.strokeStart = 0.2
//        snakeLayer.strokeEnd = 0
        
        let followPathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
        followPathAnimationStart.fromValue = 0
        followPathAnimationStart.toValue = 1
        //followPathAnimationStart.repeatCount = .infinity
        
        let followPathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
        followPathAnimationEnd.fromValue = 0.05
        followPathAnimationEnd.toValue = 1.05
//        followPathAnimationEnd.duration = 2
//        followPathAnimationEnd.autoreverses = true
        //followPathAnimationEnd.repeatCount = .infinity
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 8
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [followPathAnimationStart,followPathAnimationEnd]
        
//        snakeLayer.add(animationGroup, forKey: nil)
        //snakeLayer.add(animationGroup, forKey: nil)
        
        //cloudLayer.addSublayer(snakeLayer)
        cloudLayer.add(animationGroup, forKey: nil)
    }


}
