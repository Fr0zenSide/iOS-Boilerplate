//
//  FlipPresentAnimationController.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 09/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Variables
    // Private variables
    
    private let _originFrame: CGRect
    
    // Public variables
    
    // MARK: - Getter & Setter methods
    
    // MARK: - Constructors
    /**
     Method to create the controller with a default frame value
     
     - Parameter originFrame: mean the frame of the view at the begin of the animation
     */
    init(originFrame: CGRect) {
        _originFrame = originFrame
    }
    
    // MARK: - Init behaviors
    
    /**
     Method to explicite the animation duration
     
     - Parameter transitionContext: contain the context of the UIKit system to manage the transitions animations
     - Returns: duration of the animation
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    /**
     Method to manage the animation
     
     - Parameter transitionContext: contain the context of the UIKit system to manage the transitions animations
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        snapshot.frame = _originFrame
        snapshot.layer.cornerRadius = AppPreviewCollectionViewCell.cellCornerRadius
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransform(for: containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
                    fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                    snapshot.layer.transform = AnimationHelper.yRotation(0.0)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                    snapshot.frame = finalFrame
                    snapshot.layer.cornerRadius = 0
                }
        },
            completion: { _ in
                toVC.view.isHidden = false
                snapshot.removeFromSuperview()
                fromVC.view.layer.transform = CATransform3DIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Delegates methods
}
