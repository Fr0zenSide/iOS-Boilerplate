//
//  UIView.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 12/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit

extension UIView {
    func duplicate() -> UIView? {
        // if ios is < 11
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? UIView
        // If ios >= 11
//        do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
//            if let view = try NSKeyedUnarchiver.unarchivedObject(ofClass: type(of: self), from: data) {
//                return view
//            }
//        } catch let error {
//            print("Error when you decode this view \(self): \(error)")
//        }
//        return nil
    }
}
