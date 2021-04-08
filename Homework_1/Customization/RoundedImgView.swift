//
//  RoundedImgView.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import UIKit

@IBDesignable
class RoundedImgView: UIImageView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }

}
