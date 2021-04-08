//
//  AnimatedNavController.swift
//  Homework_1
//
//  Created by Maksim on 31.03.2021.
//

import UIKit

class AnimatedNavController: UINavigationController, UINavigationControllerDelegate {
    
    let interactiveTransition =
        CustomInteractiveTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        case .pop:
            if navigationController.viewControllers.first != toVC {
                interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    
    

}
