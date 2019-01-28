//
//  FlipDismissAnimationController.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 09/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Variables
    // Private variables
    
    private let _destinationFrame: CGRect
    
    // Public variables
    
    let interactionController: SwipeInteractionController?
    
    // MARK: - Getter & Setter methods
    
    // MARK: - Constructors
    /**
     Method to create the controller with a default frame value
     
     - Parameter destinationFrame: mean the frame of the view at the end of the animation
     - Parameter interactionController: controller who manage swipe back
     */
    init(destinationFrame: CGRect, interactionController: SwipeInteractionController?) {
        _destinationFrame = destinationFrame
        self.interactionController = interactionController
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
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        
        snapshot.layer.cornerRadius = AppPreviewCollectionViewCell.cellCornerRadius
        snapshot.layer.masksToBounds = true
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, at: 0)
        containerView.addSubview(snapshot)
        fromVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransform(for: containerView)
        toVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
                    snapshot.frame = self._destinationFrame
                }
                
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                    snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                    toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                }
        },
            completion: { _ in
                fromVC.view.isHidden = false
                snapshot.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    toVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Delegates methods
}
