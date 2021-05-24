//
//  CustomInteractiveTransition.swift
//  Homework_1
//
//  Created by Maksim on 01.04.2021.
//

import UIKit

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var viewController: UIViewController? {
        didSet{
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePanGesture))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    var hasStarted: Bool = false
    var shouldFinished: Bool = false
    
    @objc func handleScreenEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        print(#function)
        
        switch recognizer.state {
        case .began:
        hasStarted = true
        viewController?.navigationController?.popViewController(animated: true)
            
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / (recognizer.view?.frame.width ?? 1)
            
            let progress = max(0,min(1, relativeTranslation))
            
            shouldFinished = progress > 0.33
            update(progress)
            
        case .ended:
            hasStarted = false
            shouldFinished ? finish() : cancel()
        case .cancelled:
            hasStarted = false
            cancel()
        default:
            return
        }
        
    }
}
