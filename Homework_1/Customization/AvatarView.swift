//
//  AvatarView.swift
//  Homework_1
//
//  Created by Maksim on 02.03.2021.
//

import Foundation
import UIKit

@IBDesignable
class AvatarView: UIView {
 
    @IBInspectable
    var shadowColor : UIColor = UIColor.whiteClr {
        didSet{
            self.updateShadowColor()
        }
    }
    
    @IBInspectable
    var shadowWidth : CGFloat = 5 {
        didSet{
            self.updateShadowWidth()
        }
    }
    
    @IBInspectable
    var shadowOpacity : Float = 5 {
        didSet{
            self.updateShadowOpacity()
        }
    }
    
    @IBInspectable
    var avatarImage: UIImage? {
        didSet {
            imageView.image = avatarImage
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.clipsToBounds = true
        imageView.image = avatarImage
        return imageView
    }()
    
    // for spin
    var animator: UIViewPropertyAnimator!
    enum Direction {
        case left, right
        init(x: CGFloat) {
            self = x > 0 ? .right : .left
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func awakeFromNib() {
        setupView()
        
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        let avatarSpin = UIPanGestureRecognizer(target: self, action: #selector(avatarPanned(_:)))
        
        imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(avatarTap)
        self.imageView.addGestureRecognizer(avatarSpin)
    }
        
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    @objc func avatarPanned(_ recognizer: UIPanGestureRecognizer){
        guard let panView = recognizer.view else { return}
        let spinTr = recognizer.translation(in: panView)
        let spinDirection = Direction(x: spinTr.x)
        print(spinDirection)
        
        switch recognizer.state {
        case.began:
            UIView.animate(withDuration: 0.5) {
                self.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
            } completion: { (finished) in
                self.layer.transform = CATransform3DIdentity
            }
        default:
            break
        }
    }
    
    @objc func avatarTapped () {
        print("\n Avatar tapped")
        UIView.animate(
            withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.4,
                    initialSpringVelocity: 0.5,
            options: [.curveEaseIn],
                    animations: {
                        self.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.8, 0.8, 0.8)
                    },
            completion: {_ in
                self.layer.transform = CATransform3DIdentity
            })
    }
    
    func configureView(nameOfImage: String) {
        if nameOfImage.contains("light") {
            self.layer.backgroundColor = UIColor.darkGrayClr.cgColor
        } else {
            self.layer.backgroundColor = UIColor.whiteClr.cgColor
        }
    }
    
    func setupView(){
        self.layer.cornerRadius = self.bounds.width/2
        self.imageView.layer.cornerRadius = self.bounds.width/2
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        ])
    }
          
    func updateShadowColor(){
        self.layer.shadowColor = shadowColor.cgColor
    }
    
    func updateShadowOpacity(){
        self.layer.shadowOpacity = shadowOpacity
    }
    
    func updateShadowWidth(){
        self.layer.shadowRadius = shadowWidth
    }
    
}
