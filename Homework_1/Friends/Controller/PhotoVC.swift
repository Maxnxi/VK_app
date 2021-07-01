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
        
    var userPhotos : [PhotoModel] = []
    var imageIndex: Int = 0 {
        didSet{
            if userPhotos.count != 0 {
                title = "Фото \(imageIndex + 1) из \(userPhotos.count)"
            }
        }
    }
    
    // для анимации перелистывания
    var animator: UIViewPropertyAnimator!
    var inChangeImageProcess: Bool = false
    
    lazy var nextImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()

    enum Direction {
        case left, right
        init (x: CGFloat) {
            self = x > 0 ? .right : .left
        }
    }
    //-----
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configureViewNew(userPhotos: [PhotoModel], photoAtIndexPath: Int){
        self.imageIndex = photoAtIndexPath
        self.userPhotos = userPhotos
    }
    
//    func configureView(userPhotos: [PhotoRealMObject], photoAtIndexPath: Int){
//        self.imageIndex = photoAtIndexPath
//        self.userPhotos = userPhotos
//    }
    
    
    
    func setupView(){
        if imageIndex >= 0 && imageIndex < userPhotos.count {
            imagePresView.image = self.getUrlAndShowImage(url: userPhotos[imageIndex].url)
        }
        title = "Фото \(imageIndex + 1) из \(userPhotos.count)"
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pannedImage(_:)))
        imagePresView.isUserInteractionEnabled = true
        imagePresView.addGestureRecognizer(pan)
    }

    
    //MARK: -> Меняем индекс фото при перелистывании
    func changeOnLeftImage(){
       DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)) {
            if self.imageIndex > 0 {
                self.imageIndex -= 1
            } else {
                self.imageIndex = self.userPhotos.count-1
            }
        }
    }
    
    func changeOnRightImage(){
       DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)) {
        if self.imageIndex < self.userPhotos.count-1 {
                self.imageIndex += 1
            } else {
                self.imageIndex = 0
            }
        }
    }
    
    // функция вытаскивает url из UserPhoto формата тип "х"
    func getUrlAndShowImage(url: URL) -> UIImage? {
        
       // guard let stringUrl = userPhotos[indexOfPhoto].url as? String else { return UIImage() }
        
        let data = try? Data(contentsOf: url)
        
        guard let imageData = data else {
            print("Error quit #39")
            return UIImage() }
        
        let image = UIImage(data: imageData)
        
//        var image: UIImage?
//        let photoSizes = userPhotos[indexOfPhoto].sizes
//        for element in photoSizes{
//            if element.type == "x" {
//                let urlString = element.url
//
//                print("urlString is - ",urlString)
//                let data = try? Data(contentsOf: URL(string: urlString)!)
//
//                guard let imageData = data else {
//                    print("Error quit #39")
//                    break }
//
//               image = UIImage(data: imageData)
//            }
//        }
//        return image
        return image
    }

    
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
                let url = userPhotos[nextIndex].url
                nextImageView.image = getUrlAndShowImage(url: url)
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
                    self.imagePresView.image = self.getUrlAndShowImage(url: self.userPhotos[self.imageIndex].url)
                        //self.images[self.imageIndex]
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
            return imageIndex < userPhotos.count - 1
        } else {
            return imageIndex > 0
        }
    }

}
