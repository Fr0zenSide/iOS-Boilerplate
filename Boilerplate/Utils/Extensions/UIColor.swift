//
//  UIColor.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 21/01/2019.
//  Copyright © 2019 Jeoffrey Thirot. All rights reserved.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
