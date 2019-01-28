//
//  DetailTodayAppViewController.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 09/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit

class DetailTodayAppViewController: UIViewController {

    // MARK: - Variables
    // Private variables
    
    // Public variables
    
    var currentApp: App?
    var swipeInteractionController: SwipeInteractionController?
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundTitleView: UIView!
    
    // MARK: - Getter & Setter methods
    
    // MARK: - Constructors
    /**
     Method to create the manager of socket communications
     
     @param settings detail to launch the right sockets connection
     @param delegate used to dispatch event from sockets activities
     */
    
    // MARK: - Init behaviors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeInteractionController = SwipeInteractionController(viewController: self)
        
        headerImageView.contentMode = .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentApp?.getIcon(complete: { (image) in
            self.headerImageView.image = image
        })
        titleLabel.text = currentApp?.title
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Public methods
        
    @IBAction func closeHandler(_ sender: Any) {
        let vc = self.navigationController?.popViewController(animated: true)
        print("We close the viewController: <\(type(of: vc))>\(String(describing: vc))")
    }
    
    // MARK: - Private methods
    
    // MARK: - Delegates methods
}
