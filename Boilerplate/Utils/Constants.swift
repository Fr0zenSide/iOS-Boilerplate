//
//  Constants.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 07/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import Foundation

class Constants {
    // MARK: - Variables
    // Private variables
    
    // Public variables
    
    // todo: Need to add an external lib to protect this kind of data and to import it from a file ignored by git in gitignore with template
    static var apptweakToken = ""
    static var locale = "fr"
    static var country = "fr"
    
    // MARK: - Getter & Setter methods
    
    
    // MARK: - Public methods
    
    static func description() -> String {
        let desc = """
        apptweakToken: \(Constants.apptweakToken),
        locale: \(Constants.locale),
        country: \(Constants.country)
        """
        return desc
    }
    
    // MARK: - Private methods
}
