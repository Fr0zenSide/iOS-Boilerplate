//
//  AbstractModel.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 07/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit

class AbstractModel: Codable, Serializable {

    // MARK: - Variables
    // Private variables
    
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    // Public variables
    
    var id: String
    
    // MARK: - Getter & Setter methods
    
    /**
     Getter to get the name of the current class in String
     */
    public static var modelName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! // Use this to get class name from a static call
        //        return NSStringFromClass(type(of: self)) // Use this to get class name from an instance
    }
    
//    /**
//     Getter to custom the description display in console when your print an object
//     */
    public var description: String {
        var desc = "<\(type(of: self))> "
//        desc += " id: \(self.id),"
//        return desc
        // todo: Change this because it's really ugly
        if let dict = self.dictionary() {
            desc += "dictionary representation: \(dict)"
        }
        return desc
    }
    
    // MARK: - Constructors
    /**
     Method to create an abstract model
     
     */
    init(id: String) {
        self.id = id
    }
    
    init() {
        // fixme: You can get also an uuid for the next line
        let id = "\(CFAbsoluteTimeGetCurrent()))\(arc4random())"
        self.id = id
    }
    
    // Codable Methods
    
    /**
     Method to create an artist with the decode constructor which ref. to the protocol Codable or NSCoding in ObjC
     
     - Parameter decoder: object which contain all your data in Cadable/NSCoding format
     */
    required init(from decoder: Decoder) throws {
        self.id = "\(CFAbsoluteTimeGetCurrent())-\(arc4random())"
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            if let value = try? values.decode(Int.self, forKey: .id) {
                self.id = String(value)
            } else {
                self.id = try values.decode(String.self, forKey: .id)
            }
        } catch {
            fatalError("Error! When you want to decode your model: \(type(of: self).modelName)")
        }
    }

    /**
     Method to encode your data with the protocol Codable => ref. to NSCoding in ObjC

     - Parameter encoder: object require to register all your saved properties to make your model Codable compliante
     - encoder: Need to contain all your Codable/NSCoding properties
     */
    func encode(to encoder: Encoder) throws {
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
        } catch {
            fatalError("Error! When you want to encode your model: \(type(of: self).modelName) > \(self)")
        }
    }

    
    // MARK: - Public methods
    
    /**
     Method to get the url of this ressource
     
     - Parameter id: identifier of your resource
     - Returns: url to request this ressource on api
     - Warning: This is an abstract methods, you need to override it on every child.
     
     */
    class func endpointForID(_ id: String) -> String {
        fatalError("Error! If you see this message, you need to overrige the method endpointForID in \(self.modelName) class")
    }
    
    /**
     Method to create a typed data conform to Codable protocol
     
     - Parameter type: class of the model
     - Parameter data: data of the model
     - Returns: an instance of data typed by the class of type in type variable 😑
     */
    static func decodeTypedObject<T: Codable>(type: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(type.self, from: data)
            return decoded
        } catch let error {
            print("Failed to decode JSON: \(error)")
        }
        return nil
    }
    
    // MARK: - Private methods
}
