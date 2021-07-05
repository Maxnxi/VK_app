//
//  CustomPushAnimate.swift
//  Homework_1
//
//  Created by Maksim on 31.03.2021.
//

import UIKit
import Foundation

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame

        destination.view.center.x = source.view.frame.width
        destination.view.layer.anchorPoint = CGPoint(x: 1 , y: 0.5)

        let rotation = CATransform3DGetAffineTransform(CATransform3DRotate(CATransform3DIdentity, -CGFloat.pi/2, 0, 1, 0))
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
                    relativeDuration: 0.75,
                    animations: {
                        let translation = CGAffineTransform(translationX: -300, y: 0)
                        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                        source.view.transform = translation.concatenating(scale)
                    })
                // 2
                UIView.addKeyframe(
                    withRelativeStartTime: 0.2,
                    relativeDuration: 0.4,
                    animations: {
                        let rotation = CATransform3DGetAffineTransform(CATransform3DRotate(CATransform3DIdentity, CGFloat.pi/2, 0, 1, 0))
                        destination.view.transform = rotation
                    })
                // 3
                UIView.addKeyframe(
                    withRelativeStartTime: 0.6,
                    relativeDuration: 0.4,
                    animations: {
                        destination.view.transform = .identity
                    })

            }, completion: { finished in
                let finishedAndNotCancelled = finished && !transitionContext.transitionWasCancelled
                if finishedAndNotCancelled {
                    source.view.transform = .identity
                }
                transitionContext.completeTransition(finishedAndNotCancelled)
            }
        )
    }
}
    
    
    

