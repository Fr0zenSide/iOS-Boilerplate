//
//  Constants.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 07/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import Foundation
import KeychainAccess

class Constants {
    // MARK: - Variables
    // Private variables
    
    // Public variables
    
    static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? "me.jeoffrey.\(String(describing: UIDevice.current.identifierForVendor?.uuidString))"
    }
    
    static var kuzzleServerURL: String {
        switch NetworkManager.environment {
        case .production:   return "https://blast.jeoffrey.me:32800"
        case .qa:           return "http://qa.jeoffrey.me:32800/"
        case .staging:      return "http://localhost:7512"
        }
    }
    static var kuzzleWebSocketServerURL: String {
        switch NetworkManager.environment {
        case .production:   return "wss://blast.jeoffrey.me:32800"
        case .qa:           return "ws://qa.jeoffrey.me:32800/"
        case .staging:      return "ws://localhost:7512"
        }
    }
    // todo: Need to add an external lib to protect this kind of data and to import it from a file ignored by git in gitignore with template
    static var apptweakToken: String {
        let keychain = Keychain(service: "me.jeoffrey.boilerplate")
        if let token = keychain["apptweakToken"] { return token }
        return ""
    }
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
