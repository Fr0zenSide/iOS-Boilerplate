//
//  UIImageView.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 09/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
