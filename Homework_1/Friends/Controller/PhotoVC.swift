//
//  PhotoVC.swift
//  Homework_1
//
//  Created by Maksim on 25.02.2021.
//

import UIKit
import Foundation

class PhotoVC: UIViewController {

    @IBOutlet weak var imagePresView: UIImageView!
    lazy var nextImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    var animator:UIViewPropertyAnimator!
    
    var images: [UIImage] = []
    var imageIndex: Int = 0 {
        didSet{
            if images.count != 0 {
                title = "Фото \(imageIndex + 1) из \(images.count)"
            }
        }
    }

    enum Direction {
        case left, right
        init (x: CGFloat) {
            self = x > 0 ? .right : .left
        }
    }
    
    var inChangeImageProcess: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    func configureView(imageAtIndexPath: Int){
        self.imageIndex = imageAtIndexPath
    }
    
    func setupView(){
        guard let imgArr = IMAGES_ARRAY as? [UIImage] else {return}
        self.images = imgArr
        
        if imageIndex >= 0 && imageIndex < images.count {
            imagePresView.image = images[imageIndex]
        }
        
        title = "Фото \(imageIndex + 1) из \(images.count)"
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pannedImage(_:)))
        imagePresView.isUserInteractionEnabled = true
        imagePresView.addGestureRecognizer(pan)
    }

    //MARK: ->change indexOf Photo
    
    func changeOnLeftImage(){
       DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)) {
            if self.imageIndex > 0 {
                self.imageIndex -= 1
            } else {
                self.imageIndex = IMAGES_ARRAY.count-1
            }
        }
    }
    
    func changeOnRightImage(){
       DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)) {
            if self.imageIndex < IMAGES_ARRAY.count-1 {
                self.imageIndex += 1
            } else {
                self.imageIndex = 0
            }
        }
    }
    
    
    //MARK: -> Animations
//    func animateNewImage(){
//        imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
//            self.imageView.transform = .identity
//            self.imageView.alpha = 1
//        }, completion: nil)
//        print("Установлена картинка: №", imageView.image)
//        imageView.isUserInteractionEnabled = true
//        inChangeImageProcess = false
//    }
//
//    func animateTranslateExit(coordinates: CGPoint) {
//
//        let animateGroup = CAAnimationGroup()
//        animateGroup.duration = 0.1
//        animateGroup.fillMode = CAMediaTimingFillMode.both
//
//        let translationX = CABasicAnimation(keyPath: "position.x")
//        translationX.byValue = coordinates.x/1.6
//
//        let translationY = CABasicAnimation(keyPath: "position.y")
//        translationY.byValue = coordinates.y/1.6
//
//        animateGroup.animations = [translationX, translationY]
//        imageView.layer.add(animateGroup, forKey: nil)
//
//        if inChangeImageProcess == false {
//            if ( coordinates.x < -130) {
//                inChangeImageProcess = true
//                changeOnLeftImage()
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.imageView.alpha = 0
//                })
//                print("\n координаты:",imageView.center.x, self.view.frame.minX )
//                imageView.isUserInteractionEnabled = false
//                return
//
//            } else if ( coordinates.x > 130 ) {
//                inChangeImageProcess = true
//                changeOnRightImage()
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.imageView.alpha = 0
//                })
//                imageView.isUserInteractionEnabled = false
//                return
//            }
//        }
//
//    }
    
    //MARK: -> Gestures

    @objc func tapped(){
        print("tapped tapped")
        changeOnRightImage()
    }
    
    @objc func pannedImage(_ recognizer: UIPanGestureRecognizer){
        guard let panView = recognizer.view else { return}
        let translation = recognizer.translation(in: panView)
        let direction = Direction(x: translation.x)
        
        switch recognizer.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {
                self.imagePresView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
                self.imagePresView.alpha = 0
            })
            
            if canSlideIt(direction) {
                let nextIndex =  direction == .left ? imageIndex + 1 : imageIndex - 1
                nextImageView.image = images[nextIndex]
                view.addSubview(nextImageView)
                
                let offsetX = direction == .left ? view.bounds.width : -view.bounds.width
                nextImageView.frame = view.bounds.offsetBy(dx: offsetX, dy: 0)
                
                animator.addAnimations({
                    self.nextImageView.center = self.imagePresView.center
                    self.nextImageView.alpha = 1
                }, delayFactor: 0.2)
                
                animator.addCompletion { (position) in
                    guard position == .end else { return}
                    self.imageIndex = direction == .left ? self.imageIndex + 1 : self.imageIndex - 1
                    self.imagePresView.alpha = 1
                    self.imagePresView.transform = .identity
                    self.imagePresView.image = self.images[self.imageIndex]
                    self.nextImageView.removeFromSuperview()
                }
            }
            
        case .changed:
            animator.fractionComplete = abs(translation.x) / panView.frame.width

        case .ended:
            if canSlideIt(direction), animator.fractionComplete > 0.6 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {
                animator.stopAnimation(true)
                UIView.animate(withDuration: 0.2, animations: {
                    self.imagePresView.transform = .identity
                    self.imagePresView.alpha = 1
                    let offsetX = direction == .left ? self.view.bounds.width : -self.view.bounds.width
                    self.nextImageView.frame = self.view.bounds.offsetBy(dx: offsetX, dy: 0.0)
                    self.nextImageView.transform = .identity
                })
            }
 
        default:
            //todo nothing
           break
        }
        
        
        
       
    }
    
    private func canSlideIt(_ direction: Direction) -> Bool {
        if direction == .left {
            return imageIndex < images.count - 1
        } else {
            return imageIndex > 0
        }
    }
    
}
