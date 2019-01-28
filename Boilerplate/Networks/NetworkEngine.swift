//
//  NetworkEngine.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 07/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import Foundation

class NetworkEngine {
    
    // MARK: - Variables
    // Private variables
    
    private var _cache = NSCache<NSString, AnyObject>()
    private var _cacheKey = "network.cache"
    
    // Public variables
    
    public enum APIKeyEndPoint {
        case famousApp
        case appDetails
        case searchApp(name: String)
        
        func endPoint(_ id: String? = "") -> URLComponents {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.apptweak.com"
            var path: String = ""
            switch self {
            case .famousApp:
//                path = "/ios/applications/0/trends.json" // No 400 code status when you have error on the api 😭
                path = "/ios/categories/0/top.json"
//            case .trendApp:
//                if id != nil {
//                    route = Artist.endpointForID(id!)
//                }
            case .appDetails:
                if let safeId = id {
                    path =  App.endpointForID(safeId)
                }
            case .searchApp(let query):
//                /ios/searches.json?term=angry&country=be&language=nl&device=ipad
                path = "/ios/searches.json"
                components.queryItems = [URLQueryItem(name: "term", value: query)]
                // /ios/keywords/trendings.json?country=uk // can be use for a placeholder of search page
            default:
                print("Warning! If you see this message you need to manage the default behavior here...")
                components.host = "youtu.be"
                path = "/OWFBqiUgspg"
            }
            components.path = path
            return components
        }
    }
    
    enum Result {
        case success(response: [String: Any]?)
        case error(error: String)
    }
 
 
    // MARK: - Getter & Setter methods
    
    // MARK: - Constructors
    /**
     Method to create the manager of http communications
     
     */
    init() {
        
        let defaults = UserDefaults.standard
        if let cache = defaults.object(forKey: _cacheKey) as? NSCache<NSString, AnyObject> {
            _cache = cache
        } else {
            _cache = NSCache()
        }
    }
    
    // MARK: - Init behaviors
    
    // MARK: - Public methods
    
    /**
     Method to manage call api with get method
     
     - Parameter key: keyword of the current request you want to execute
     - Parameter data: dictionary with all variable you want to use for your request
     - Parameter complete: closure called when your request is finished
     */
    func getRessource(for key: APIKeyEndPoint, with data: [String: Any], complete: @escaping ((_ result: Result) -> Void)) {
        // todo: need to change the next condition, all get don't require an id like a list of resources
        guard let id = data["id"] as? String else {
            // todo manage exceptions here late
            print("Warning! you doesn't have a property id on your data: \(data)")
            return
        }
        
        var urlComponents = key.endPoint(id)
        if urlComponents.queryItems == nil {
           urlComponents.queryItems = []
        }
        for (key, value) in data {
            if let stringValue = value as? String {
                urlComponents.queryItems?.append(URLQueryItem(name: key, value: stringValue))
            }
        }
        guard let url = urlComponents.url else {
            fatalError("Error! I can create an url with this context.")
        }
        
        var request = URLRequest(url: url)
        // todo: Need to find an other way to use header in the app
        request.addValue(Constants.apptweakToken, forHTTPHeaderField: "X-Apptweak-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if error != nil {
                complete(.error(error: "My custom error message"))
                return
            }
            
            var result = [String: Any]()
            result["message"] = "Success for your request: \(url)"
            print("Request succeeded for: \(url)")
            if data != nil {
                result["data"] = data!
                do {
                    if let parsedResult: [String: AnyObject] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] {
                        result["json"] = parsedResult
                    }
                } catch let error {
                    print("Error! This data is not a json compliante. \(error)")
                }
            }
            complete(.success(response: result))
        })
        task.resume()
    }
    
    // todo: Change saving cache method because the UserDefaults data is not make for that
    // and it can not register list but codable or string properties
    // MARK: Method to add CRUD on cache
    func saveCache() {
        let defaults = UserDefaults.standard
        defaults.set(_cache, forKey: _cacheKey)
        defaults.synchronize()
    }
    
    func deleteCache() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: _cacheKey)
        defaults.synchronize()
    }
    
    // MARK: Method to manage cache
    func addToCache(for key: String, data: String) {
        _cache.setObject(data as AnyObject, forKey: key as NSString)
    }
    
    func getToCache(from key: String) -> String? {
        return _cache.object(forKey: key as NSString) as? String
    }
    
    // MARK: - Private methods
    
    // MARK: - Delegates methods
}
