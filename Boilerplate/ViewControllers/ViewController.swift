//
//  ViewController.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 14/12/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit
import CocoaLumberjack
import Moya
import QuartzCore

class ViewController: UIViewController {

    // MARK: - Variables
    // Private variables
    
    // Public variables
    
    weak var leftConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    var tryWebSocket: WebSocketKuzzleConnector!
    
    // MARK: - Getter & Setter methods
    
    // MARK: - Constructors
    // MARK: - Init behaviors
    
    override func loadView() {
        super.loadView()
        
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 115, height: 30) // 95
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle("🚀🚀🚀 ?AA", for: .normal)
        view.addSubview(button)
//        button.addTarget(self, action: #selector(_buttonHandler(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(self._buttonHandler), for: .touchUpInside)
        
        // Button styles
        let safeArea = self.view.safeAreaLayoutGuide
        leftConstraint = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        bottomConstraint = button.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0)
        heightConstraint = button.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([
            leftConstraint,
            bottomConstraint,
            button.widthAnchor.constraint(equalToConstant: 115),
            heightConstraint
            ])
        
        // We can also write constraint like next two lines
//        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        button.centerYAnchor.constraint(equalTo: view.lastBaselineAnchor, constant: -100).isActive = true
        
//        print("button.constraints: \(button.constraints)")
        /*
         // Need to override in class directly
         // You’ve set up constraints so that chapterLabel‘s top is anchored to avatarView‘s bottom and chapterLabel‘s bottom is anchored to the text view’s top. But when you don’t set an explicit constraint for Width and Height, the Auto Layout engine has to take intrinsic content size as a guide rather than a rule. In this situation it has given priority to avatarView‘s intrinsic size over chapterLabel‘s.
         
         chapterLabel has consequently stretched vertically in a rather uncomfortable manner:
        override var intrinsicContentSize: CGSize {
            return CGSize(width: UIViewNoIntrinsicMetric, height: 30)
        }
        */
        /*
         // There are two methods associated with intrinsic content size that give priorities to which views should stretch and compress.
         
         // setContentHuggingPriority(_:for:) takes a priority and an axis to determine how much a view wants to stretch. A high priority means that a view wants to stay the same size. A low priority allows the view to stretch.
         
         // setContentCompressionResistancePriority(_:for:) also takes a priority and an axis. This method determines how much a view wants to shrink. A high priority means that a view tries not to shrink and a low priority means that the view can squish.
         
         // Note: Priorities are values between 1 and 1000, where 1000 is the highest. The standard priorities are UILayoutPriorityRequired = 1000, UILayoutPriorityDefaultHigh = 750 and UILayoutPriorityDefaultLow = 250.
 
         */
        button.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        button.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        
        // Button UI styles
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = button.frame.height * 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DDLogDebug("World 🎉")
        
        let provider = MoyaProvider<KuzzleService>()
        provider.request(.hello) { (result) in
            var statusCode: Int
            switch result {
            case let .success(response):
                // Convert JSON String to Model
                let JSONString = String(data: response.data, encoding: .utf8)
                statusCode = response.statusCode
                DDLogDebug("data: \(JSONString!)")
            case let .failure(error):
                DDLogDebug("Failure request :( \(error.localizedDescription)")
                statusCode = (error.response?.statusCode != nil ? (error.response?.statusCode)! : 418)
            }
            DDLogDebug("Request on server(\(KuzzleService.hello.path)) with status: \(statusCode)")
        }
        
        provider.rx.request(.hello).subscribe { event in
            switch event {
            case let .success(response):
                DDLogDebug("Rx response: \(response)")
                let JSONString = String(data: response.data, encoding: .utf8)
                DDLogDebug("Rx data: \(JSONString!)")
            case let .error(error):
                DDLogDebug("Rx error: \(error)")
            }
        }
        
        tryWebSocket = WebSocketKuzzleConnector()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "mainToSecondVC" {
            if let myDestination = segue.destination as? SecondViewController {
                myDestination.data = "Come from main page"
            }
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    @objc private func _buttonHandler(_ sender: UIButton?) {
        // go to next page
        print("Button was touched 💥")
//        CLSLogv("%@", getVaList(["Cause Crash button touched"]))
//        Crashlytics.sharedInstance().crash()
//        assert(false)
        self.performSegue(withIdentifier: "mainToSecondVC", sender: self)
        
        // You want to animate constraint:
        /*
        if self.leftConstraint.constant != 0 {
            self.leftConstraint.constant = 0
        } else {
            self.leftConstraint.constant = 64
        }
        
        if self.bottomConstraint.isActive {
            NSLayoutConstraint.deactivate([self.bottomConstraint])
            NSLayoutConstraint.activate([self.heightConstraint])
            
        } else {
            NSLayoutConstraint.deactivate([self.heightConstraint])
            NSLayoutConstraint.activate([self.bottomConstraint])
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        */
    }
}

