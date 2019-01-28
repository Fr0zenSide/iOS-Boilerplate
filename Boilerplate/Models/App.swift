//
//  App.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 07/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit

enum Device: String, Codable {
    case ipad, iphone, ipod, tvos
}

class App: AbstractModel {

    // MARK: - Variables
    // Private variables
    
    private var _cacheKeyPatern = "Apps.info."
    
    private enum CodingKeys: String, CodingKey {
        case title, icon, developer, price, genres, devices, slug, rating
        case inApps = "in_apps"
    }
    
    // Public variables
    
    var title: String
    var icon: String
    var developer: String
    var price: String
    var genres: [Int]
    var devices: [Device]
    var slug: String
    var rating: Double
    var inApps: Bool
    
    // MARK: - Getter & Setter methods
    
    var iconUrl: URL? {
        return URL(string: self.icon)
    }
    
    // MARK: - Constructors
    /**
     Method to create an instance of App model
     
     @param settings detail to launch the right sockets connection
     @param delegate used to dispatch event from sockets activities
     - Parameter id: unique identifier
     - Parameter title: title of this app
     - Parameter icon: url of the app icon
     - Parameter developer: name of the company behind the app
     - Parameter price: price of the app
     - Parameter genres: array of genre identifiers
     - Parameter devices: list of compatible devices
     - Parameter slug: URL friendly version of the app name
     - Parameter rating: rating in the store of this app
     - Parameter inApps: has in app purchases?
     - Returns: an instance of this model
     */
    init(id: String, title: String, icon: String, developer: String, price: String, genres: [Int], devices: [Device], slug: String, rating: Double, inApps: Bool) {
        self.title      = title
        self.icon       = icon
        self.developer  = developer
        self.price      = price
        self.genres     = genres
        self.devices    = devices
        self.slug       = slug
        self.rating     = rating
        self.inApps     = inApps
        super.init(id: id)
    }
    
    // MARK: - Init behaviors
    
    /**
     Method to create an artist with the decode constructor which ref. to the protocol Codable or NSCoding in ObjC
     
     - Parameter decoder: object which contain all your data in Cadable/NSCoding format
     */
    required init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try values.decode(String.self, forKey: .title)
            self.icon = try values.decode(String.self, forKey: .icon)
            self.developer = try values.decode(String.self, forKey: .developer)
            self.price = try values.decode(String.self, forKey: .price)
            self.genres = try values.decode([Int].self, forKey: .genres)
            self.devices = try values.decode([Device].self, forKey: .devices)
            self.slug = try values.decode(String.self, forKey: .slug)
            self.rating = try values.decode(Double.self, forKey: .rating)
            self.inApps = try values.decode(Bool.self, forKey: .inApps)
        } catch {
            fatalError("Error! When you want to decode your model: \(AbstractModel.modelName)")
//            fatalError("Error! When you want to decode your model: \(type(of: self).modelName)")
        }
        try super.init(from: decoder)
    }
    
    /**
     Method to encode your data with the protocol Codable => ref. to NSCoding in ObjC
     
     - Parameter encoder: object require to register all your saved properties to make your model Codable compliante
     - encoder: Need to contain all your Codable/NSCoding properties
     */
    override func encode(to encoder: Encoder) throws {
        do {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encode(icon, forKey: .icon)
            try container.encode(developer, forKey: .developer)
            try container.encode(price, forKey: .price)
            try container.encode(genres, forKey: .genres)
            try container.encode(devices, forKey: .devices)
            try container.encode(slug, forKey: .slug)
            try container.encode(rating, forKey: .rating)
            try container.encode(inApps, forKey: .inApps)
        } catch {
            fatalError("Error! When you want to encode your model: \(type(of: self).modelName) > \(self)")
        }
    }
    
    // MARK: - Public methods
    
    /**
     Method to get the image object relative to the icon property
     
     - Parameter complete: closure called when the icon is available for a view
     */
    func getIcon(complete: @escaping ((_ image: UIImage) -> Void)) {
        // todo: refacto the cache behavior to have a generic cache management
        let cachePath = NSTemporaryDirectory()
        if let url = iconUrl {
            let fileExtension = url.pathExtension
            // check if file is in temp folder to load it from local
            let fileUrl = URL(fileURLWithPath: cachePath).appendingPathComponent(id).appendingPathExtension(fileExtension)
            if FileManager.default.fileExists(atPath: fileUrl.path),
                let data = try? Data(contentsOf: fileUrl),
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    complete(image)
                }
                return // stop the execution
            }
            
            // else download the image and save it in local
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    try? data.write(to: fileUrl)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            complete(image)
                        }
                    }
                }
            }
        }
    }
    
    /**
     Method to get the url of this ressource
     
     - Parameter id: identifier of your ressource
     - Returns: url to request this ressource on api
     */
    override class func endpointForID(_ id: String) -> String {
        return "/ios/applications/\(id).json"
    }
    
    // MARK: - Private methods
    
    // MARK: - Delegates methods
}
