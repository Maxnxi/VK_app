//
//  ExtUIColor.swift
//  Homework_1
//
//  Created by Maksim on 21.07.2021.
//

import UIKit

extension UIColor {
    static let whiteClr = UIColor.white
    static let lightGrayClr = UIColor.lightGray
    static let darkGrayClr = UIColor.darkGray
    
    
    static let randomClr: UIColor = {
        let randomRedColor =  Double.random(in: 0...1)
        let randomGreenColor =  Double.random(in: 0...1)
        let randomBlueColor =  Double.random(in: 0...1)
        return UIColor(red: CGFloat(randomRedColor), green: CGFloat(randomGreenColor), blue: CGFloat(randomBlueColor), alpha: 1)
    }()
}
