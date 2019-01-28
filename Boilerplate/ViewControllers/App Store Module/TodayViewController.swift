//
//  TodayViewController.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 07/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit
import QuartzCore

class TodayViewController: UIViewController {

    // MARK: - Variables
    // Private variables
    
    private var _defaultCellIdentifier = "defaultAppPreviewCell"
    private var _appCellIdentifier = "customAppPreviewCell"
    
    private var _apps: Apps?
    private var _currentAppSelected: App?
    private var _selectedFrame: CGRect?
    
    // Public variables
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Getter & Setter methods
    
    var selectedCell: UICollectionViewCell? {
        guard let currentIndex = collectionView.indexPathsForSelectedItems?.first else { return nil }
        return collectionView.cellForItem(at: currentIndex)
    }
    
    // MARK: - Constructors
    
    // MARK: - Init behaviors
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Settup the default values of env. variables
        if let language = Locale.preferredLanguages.first, // en || fr
            let regionCode = Locale.current.regionCode { // US
            Constants.locale = language
            Constants.country = regionCode.lowercased()
            // todo: maybe add the type of your current device to filter only the apps available for your device
        }
        
        view.backgroundColor = UIColor(red: 253.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1.0)
        
        collectionView.delegate = self
        collectionView.dataSource = self

        // Get directly a default collection of data for debuging before the cache was implemented
        // _populateFakeDataToTestInOffline()

        
        Apps.getTopAppsList { (apps) in
            guard let apps = apps else { return print("You can not get the top 200 of the apps") }
            print("Best apps are => \(apps)")
            self._apps = apps
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Hi Today 🚀")
        
        // Animation to display tab bar smoothly with the transition animation if needed
        if let tabBar = self.tabBarController?.tabBar,
            !CATransform3DEqualToTransform(tabBar.layer.transform, CATransform3DIdentity) {
            tabBar.layer.transform = CATransform3DMakeTranslation(0, tabBar.bounds.height, 0)
            self.transitionCoordinator?.animateAlongsideTransition(in: tabBar, animation: { (context) in
                tabBar.layer.transform = CATransform3DIdentity;
            }, completion: { (context) in
                
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // made disappear the tab bar
        if let tabBar = self.tabBarController?.tabBar {
            tabBar.layer.transform = CATransform3DIdentity;
            self.transitionCoordinator?.animateAlongsideTransition(in: tabBar, animation: { (context) in
                tabBar.layer.transform = CATransform3DMakeTranslation(0, tabBar.bounds.height, 0)
            }, completion: { (context) in
            })
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "todayToDetailVC" {
            if let myDestination = segue.destination as? DetailTodayAppViewController {
                myDestination.currentApp = _currentAppSelected
                myDestination.transitioningDelegate = self
//                myDestination.modalPresentationStyle = .custom
//                myDestination.hidesBottomBarWhenPushed = true // don't hide him because you have glich with update un autolayout when you go back on this page and tab bar appear
                // Maybe launch the request to have more detail of the page here to have no latency when you display the next page
            }
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    /**
     Method to fake a call api usefull when you need to test without api
     
     */
    private func _populateFakeDataToTestInOffline() {

        // todo: Can I replace this by a mock ?
        var collection = [App]()
        for i in 0...100 {
            let app = App(id: "1247-2543-\(i)", title: "My Super App", icon: "tchuss.png", developer: "me - \(i)", price: "0 €", genres: [0], devices: [Device(rawValue: "iphone")!, .ipad], slug: "hello", rating: 4.5, inApps: false)
            collection.append(app)
        }
        let apps = Apps(content: collection)
        _apps = apps
        collectionView.reloadData()
    }
    
    // MARK: - Delegates methods
}

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _apps?.content.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let currentData = _apps?.content[indexPath.row] else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: _defaultCellIdentifier, for: indexPath)
        }
        
        if let appCell = collectionView.dequeueReusableCell(withReuseIdentifier: _appCellIdentifier, for: indexPath) as? AppPreviewCollectionViewCell {
            appCell.data = currentData
            return appCell
        }
        
        // Manage my cell with the default behavior
        return collectionView.dequeueReusableCell(withReuseIdentifier: _defaultCellIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentData = _apps?.content[indexPath.row] else { return }
        
        _currentAppSelected = currentData // remove this property if I don't use prepare for segue
        
        // If you want to push directly the vc
//        if let detailVC =  self.storyboard?.instantiateViewController(withIdentifier: "detailTodayAppVC") as? DetailTodayAppViewController {
//            detailVC.currentApp = currentData
//            detailVC.transitioningDelegate = self
//            self.navigationController?.pushViewController(detailVC, animated: true)
//        }
        // Or use the behavior describe in prepare for segue
        let theAttributes: UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        let selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        _selectedFrame = selectedFrame
        self.performSegue(withIdentifier: "todayToDetailVC", sender: self)
    }
}


extension TodayViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    private func _itemsPerRow() -> CGFloat {
        // need to adapt if you have an iPad or iPhone and for different orientation
        var num: CGFloat = 1
        let isIPhone = (UIDevice.current.userInterfaceIdiom == .phone)
        let screenBounds = UIScreen.main.bounds
        if isIPhone {
            num = screenBounds.width > screenBounds.height ? 2 : 1
        } else {
            num = screenBounds.width > screenBounds.height ? 4 : 3
        }
        return num
    }
    
    private func _defaultSectionInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }
    
    private func _collectionViewCellWidth(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> CGFloat {
        let minPaddingSpace = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
        let itemsPerRow = _itemsPerRow()
        let paddingSpace = minPaddingSpace * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.size.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return widthPerItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = _collectionViewCellWidth(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let height = (UIDevice.current.userInterfaceIdiom == .pad) ? widthPerItem * 1.1 : widthPerItem * 1.2
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
        let defaultSectionInsets = _defaultSectionInsets()
        if cellCount < _itemsPerRow() {
            let cellSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
            let cellWidth = _collectionViewCellWidth(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
            var inset = (collectionView.bounds.size.width - (cellCount * (cellWidth + cellSpacing) /*- cellSpacing*/)) * 0.5
            inset = max(inset, defaultSectionInsets.left)
            return UIEdgeInsets(top: 20.0, left: inset, bottom: 20.0, right: inset)
        }
        return defaultSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return _defaultSectionInsets().left
    }
}

extension TodayViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let cellViewFrame = _selectedFrame ?? CGRect.zero
        switch operation {
        case .push:
            return ZoomPresentAnimationController(originFrame: cellViewFrame)
        default:
            let interactionCtrl = (fromVC as? DetailTodayAppViewController)?.swipeInteractionController
            let pageViewFrame = view.bounds
            return FlipDismissAnimationController(destinationFrame: pageViewFrame, interactionController: interactionCtrl)
        }
    }
}

// todo: Need of this protocol only when you don't have a navigation controller ?
extension TodayViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let selectedCellViewFrame = _selectedFrame ?? CGRect.zero
        return ZoomPresentAnimationController(originFrame: selectedCellViewFrame)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let revealVC = dismissed as? DetailTodayAppViewController else {
            return nil
        }
        let selectedCellViewFrame = _selectedFrame ?? CGRect.zero
        return FlipDismissAnimationController(destinationFrame: selectedCellViewFrame/*cardView.frame*/, interactionController: revealVC.swipeInteractionController)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? FlipDismissAnimationController,
            let interactionController = animator.interactionController,
            interactionController.interactionInProgress
            else {
                return nil
        }
        return interactionController
    }

}
