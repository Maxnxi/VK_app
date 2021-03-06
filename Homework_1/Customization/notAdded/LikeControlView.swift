//
//  LikeControl.swift
//  Homework_1
//
//  Created by Maksim on 12.03.2021.
//
import Foundation
import UIKit

@IBDesignable
class LikeControlView: UIView {
    
    var rectangleToDisplay: CGRect? {
        didSet {
            setupView()
        }
    }
    
    var imageHeart = UIImageView()
    var heartImg: UIImage? = UIImage(named: "heart1") {
        didSet {
            imageHeart.image = heartImg
            setNeedsDisplay()
        }
    }
    
    var numOfLikeLbl = UILabel()
    var numOfLikes: Int = 0 {
        didSet {
            self.updateNumOfLikes()
        }
    }
        
    var likedStatus: Bool = false {
        didSet{
            self.changeHeartImg()
            self.changeNumOfLikes()
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
    
    func configureView(rectangleToDisplay:CGRect, numOflikes: Int) {
        self.rectangleToDisplay = rectangleToDisplay
        self.numOfLikes = numOflikes
        print(#function, numOflikes)
    }
    
    func setupView() {
        self.layer.backgroundColor = UIColor.lightGrayClr.cgColor
        self.layer.opacity = 0.7
        self.layer.cornerRadius = 3
        
        guard let rect = rectangleToDisplay else {return}
        let imageRect = CGRect(x: rect.width - rect.height+1 , y: 0+1, width: rect.height-2 , height: rect.height-2)
        imageHeart.frame = imageRect
        imageHeart.image =  UIImage(named: "heart1")
        addSubview(imageHeart)
        
        let lblRect = CGRect(x: rect.origin.x,
                             y: rect.origin.y-10,
                             width: 40,
                             height: 40
        )
        numOfLikeLbl.frame = lblRect
        numOfLikeLbl.text = String("")
        print(numOfLikes)
        print(numOfLikeLbl.text)
        numOfLikeLbl.font = .boldSystemFont(ofSize: 14)
        numOfLikeLbl.textAlignment = .right
        numOfLikeLbl.textColor = UIColor.lightGrayClr
        addSubview(numOfLikeLbl)
              
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeControlTapped))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        view.addGestureRecognizer(tap)
        addSubview(view)
    }
    
    func updateNumOfLikes(){
        self.numOfLikeLbl.text = String("\(numOfLikes)")
    }
    
    @objc func likeControlTapped(){
        changeLikeStatus()
        print("\n tapped, numOfLikes: " , numOfLikeLbl.text ,numOfLikes)
        animateTransitionView()
    }
    
    func changeLikeStatus(){
            if likedStatus == false {
                self.likedStatus = true
            } else {
                self.likedStatus = false
            }
        }
    
    func changeNumOfLikes() {
        if likedStatus == true {
            numOfLikeLbl.textColor = UIColor.red
            numOfLikes += 1
        } else {
            numOfLikeLbl.textColor = UIColor.lightGrayClr
            numOfLikes -= 1
        }
    }
    
    func changeHeartImg(){
        if likedStatus == true {
            heartImg = UIImage(named: "heart1.fillred")!
            setNeedsDisplay()
        } else {
            heartImg = UIImage(named: "heart1")!
            setNeedsDisplay()
        }
    }
    
    func animateTransitionView(){
        UIView.transition(with: numOfLikeLbl, duration: 0.5, options: [.transitionFlipFromTop]) {
        } completion: { (Bool) in
        }
    }
}
