//
//  SecondViewController.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 21/01/2019.
//  Copyright © 2019 Jeoffrey Thirot. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    // MARK: - Variables
    // Private variables
    
    private var _regularConstraints: [NSLayoutConstraint] = []
    private var _compactConstraints: [NSLayoutConstraint] = []
    
    
    // Public variables
    
    @IBOutlet var buttons: [UIButton]!
    
    
    var data: String?
    
    // MARK: - Getter & Setter methods
    
    // MARK: - Constructors
    /**
     Method to create the manager of socket communications
     
     @param settings detail to launch the right sockets connection
     @param delegate used to dispatch event from sockets activities
     */
    
    // MARK: - Init behaviors
    override func loadView() {
        super.loadView()
        
        let safeArea = view.safeAreaLayoutGuide
        buttons.forEach { (button) in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .random()
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(self._buttonHandler), for: .touchUpInside)
            
            _regularConstraints.append(button.bottomAnchor.constraint(equalToSystemSpacingBelow: safeArea.bottomAnchor, multiplier: 0.8))
            _regularConstraints.append(button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25))
            _regularConstraints.append(button.widthAnchor.constraint(equalTo: button.heightAnchor))
            
            _compactConstraints.append(button.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10))
            _compactConstraints.append(button.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 10))
            _compactConstraints.append(button.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1.0/6.0))
        }
        
        if let constraint = buttons.first?.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5) {
            _regularConstraints.append(constraint)
        }
        
        if let constraint = buttons.first?.topAnchor.constraint(equalTo: safeArea.centerYAnchor) {
            _compactConstraints.append(constraint)
        }
//        _compactConstraints.append(safeArea.heightAnchor.constraint(equalTo: buttons.first?.topAnchor, multiplier: 0.5))
//        buttons.first?.topAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutYAxisAnchor>#>, multiplier: <#T##CGFloat#>)
//        _compactConstraints.append(buttons.first?.topAnchor.constraint(equalToSystemSpacingBelow: safeArea.heightAnchor, multiplier: 0.5))
        
        for (index, button) in buttons.enumerated() {
            print("btn[\(index)]: \(button)")
            if index <= 0 { continue }
            
            _regularConstraints.append(button.leadingAnchor.constraint(equalTo: buttons[index-1].trailingAnchor, constant: 5))
            
            _compactConstraints.append(button.topAnchor.constraint(equalTo: buttons[index-1].bottomAnchor, constant: 2))
        }
        
        _activateCurrentConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Second view is loaded with data: \(String(describing: data))")
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    @objc private func _buttonHandler(_ sender: UIButton?) {
        // go to next page
        print("Buttons[\(String(describing: sender?.tag))] was touched 💥💥")
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "todayVC") as? TodayViewController else {
            print("You have a problem here!")
            return
        }
        
        self.navigationController?.present(vc, animated: true, completion: {
            print("My today app screen are displayed 💥")
        })
    }

    private func _activateCurrentConstraints() {
        NSLayoutConstraint.deactivate(_compactConstraints + _regularConstraints)
        
        if self.traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(_regularConstraints)
        } else {
            NSLayoutConstraint.activate(_compactConstraints)
        }
    }
    
    // MARK: - rotation support
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // MARK: - trait collections
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        _activateCurrentConstraints()
    }
}
