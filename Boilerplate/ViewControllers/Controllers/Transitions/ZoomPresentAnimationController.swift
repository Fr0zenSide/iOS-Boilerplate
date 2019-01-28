//
//  ZoomPresentAnimationController.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 09/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit
import QuartzCore

class ZoomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        return 0.3
    }
    
    /**
     Method to manage the animation
     
     - Parameter transitionContext: contain the context of the UIKit system to manage the transitions animations
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? TodayViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? DetailTodayAppViewController,
            let currentCell = fromVC.selectedCell as? AppPreviewCollectionViewCell
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        // setNeedsLayout() doesn't compute the layout now because it's async but the layoutIfNeeded() method is not like that
        // To see more detail => https://medium.com/@abhimuralidharan/ios-swift-setneedslayout-vs-layoutifneeded-vs-layoutsubviews-5a2b486da31c
        toVC.view.layoutIfNeeded()
        // Get the usefull frame for the animation
        let originFrame = fromVC.collectionView.convert(currentCell.frame, to: fromVC.view)
        // todo: fix that I don't know why the imageView don't send me the right frame even with an invalidation of layout with toVC.view.setNeedsLayout
        // is equal to (0.0, 20.0, 375.0, 333.5)  should be equal to =>    (0 44; 414 448)
        // Need to add the height of Status bar
        var finalImageFrame = toVC.headerImageView.frame // toVC.view.convert(toVC.headerImageView.frame, to: toVC.view) // The same
        finalImageFrame.origin.y += 44
        let finalBgTitleFrame = toVC.backgroundTitleView.frame
        
        // Duplicate view of the cell to create an fake cell
        let imageVC = UIImageView(image: currentCell.backgroundImageView.image)
        imageVC.contentMode = currentCell.backgroundImageView.contentMode
        guard let title = currentCell.titleLabel.duplicate() as? UILabel else { print("Error with the title"); return; }
        guard let bgTitle = currentCell.backgroundTitleView.duplicate() else { print("Error with the background of the title"); return; }
        
        // Duplicate visually the cell to animate it
        let view = UIView(frame: originFrame)
        view.layer.cornerRadius = AppPreviewCollectionViewCell.cellCornerRadius
        view.layer.masksToBounds = true
        
        imageVC.frame = view.bounds
        title.frame = currentCell.titleLabel.frame
        bgTitle.frame = currentCell.backgroundTitleView.frame
        
        view.addSubview(imageVC)
        view.addSubview(bgTitle)
        view.addSubview(title)
        
        // Add new new in container to see it and prepare the others views for the animation
        containerView.backgroundColor = .white
        containerView.addSubview(view)
        containerView.addSubview(toVC.view)
        toVC.view.alpha = 0
        currentCell.isHidden = true
        
        var finalTitleFrame = title.frame
        finalTitleFrame.origin.x += 50
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                
                UIView.animate(withDuration: 0.2, animations: {
                    title.frame = finalTitleFrame
                    title.alpha = 0
                }, completion: nil)
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 2/3) {
                    view.frame = finalImageFrame
                    imageVC.frame = CGRect(origin: CGPoint.zero, size: finalImageFrame.size)
                    bgTitle.frame = finalBgTitleFrame
                    view.layer.cornerRadius = 0
                }
        },
            completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    toVC.view.alpha = 1
                }, completion: { (stopped) in
                    view.removeFromSuperview()
                    currentCell.isHidden = false
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
        })
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Delegates methods
}
