//
//  CustomPopAnimate.swift
//  Homework_1
//
//  Created by Maksim on 31.03.2021.
//
import UIKit
import Foundation

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = source.view.frame
        
        destination.view.center.x = 0
        destination.view.layer.anchorPoint = CGPoint(x: 0 , y: 0.5)
        let rotation = CATransform3DGetAffineTransform(CATransform3DRotate(CATransform3DIdentity, CGFloat.pi/2, 0, 1, 0))
        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
        destination.view.transform = rotation.concatenating(scale)
        
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [],
            animations: {
                // 1
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 1/3,
                    animations: {
                        let translation = CGAffineTransform(translationX: source.view.frame.width, y: 0)
                        let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        source.view.transform = translation.concatenating(scale)
                    })
                // 2
                UIView.addKeyframe(
                    withRelativeStartTime: 1/3,
                    relativeDuration: 1/3,
                    animations: {
                        _ = CATransform3DGetAffineTransform(CATransform3DRotate(CATransform3DIdentity, -CGFloat.pi/2, 0, 1, 0))
                    })
                // 3
                UIView.addKeyframe(
                    withRelativeStartTime: 2/3,
                    relativeDuration: 1/3,
                    animations: {
                        destination.view.transform = .identity
                    })
                
            }, completion: { finished in
                let finishedAndNotCancelled = finished && !transitionContext.transitionWasCancelled
                
                if finishedAndNotCancelled {
                    source.removeFromParent()
                    source.view.transform = .identity
                } else if transitionContext.transitionWasCancelled {
                    destination.view.transform = .identity
                }
                transitionContext.completeTransition(finishedAndNotCancelled)
            }
        )
    }
}
