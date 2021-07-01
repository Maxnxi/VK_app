//
//  extUIView.swift
//  Homework_1
//
//  Created by Maksim on 01.07.2021.
//

import Foundation
import UIKit
    
extension UIView {
    
    static func startLoadingCloudAnimation(view: UIView, time: Int) {
        //animation
        let loadingView = LoadingAnimationView(frame: CGRect(x: 30, y: 30, width: view.frame.width-60, height: view.frame.height-60))
        view.addSubview(loadingView)
        loadingView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(time)) {
                        UIView.animate(withDuration: 0.9) {
                            
                            view.addSubview(loadingView)
                            loadingView.alpha = 0
                        } completion: { (finished) in
                            loadingView.isHidden = true
                        }
            print("Loading completed")
            view.willRemoveSubview(loadingView)
            view.isHidden = true
                }
    }
}
