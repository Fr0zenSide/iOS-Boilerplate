//
//  Codable.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 08/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import Foundation

protocol Serializable: Codable {
    func dictionary() -> [String: AnyObject]?
    func data() -> Data?
}

extension Serializable {
    
    
    /**
     Method to get a json of the current instance of a Codable variable
     
     - Returns: json contained the current values of an instance conform to the Codable protocol
     
     */
    func JSONString() -> String? {
        if let data = self.data() {
            let JSONString = String(data: data, encoding: .utf8)
            return JSONString
        }
        return nil
    }
    
    /**
     Method to get a dictionary of the current instance of a Codable variable
     
     - Returns: dictionary contained the current values of an instance conform to the Codable protocol
     
     */
    func dictionary() -> [String: AnyObject]? {
        guard let data = try? JSONEncoder().encode(self),
            let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            else { return nil }
        return result
    }
    
    /**
     Method to export data of your current instance of a Codable variable
     
     - Returns: a data with your current model encoded
     
     */
    func data() -> Data? {
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            return jsonData
        }
        catch {
            print("Failed to encode \(self) in json")
        }
        return nil
    }
}
