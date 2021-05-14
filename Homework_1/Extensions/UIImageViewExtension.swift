//
//  UIImageViewExtension.swift
//  Homework_1
//
//  Created by Maksim on 12.03.2021.
//

import Foundation
import UIKit

extension UIImageView {
    
    func makeRounded(cornerRadius: CGFloat, borderWidth: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}
