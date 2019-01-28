//
//  CGFloat.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 21/01/2019.
//  Copyright © 2019 Jeoffrey Thirot. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
