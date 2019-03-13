//
//  NetworkManager.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 11/03/2019.
//  Copyright © 2019 Jeoffrey Thirot. All rights reserved.
//

import Foundation
import Moya

enum APIEnvironment {
    case staging
    case qa
    case production
}

struct NetworkManager {
    // MARK: - Variables
    // Private variables
    
    // Public variables
    
    static let environment: APIEnvironment = .staging
    static var kuzzleJWT: String = ""
    
    let provider: MoyaProvider<KuzzleService>
    
    // MARK: - Getter & Setter methods
    
    // MARK: - Constructors
    /**
     Method to create the manager of network communications
     */
    init() {
        // Setup the cache configuration for network engine
        let memoryCapacity = 200 * 1024 * 1024 // 200 MB
        let diskCapacity = 50 * 1024 * 1024 // 50 MB
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: NSTemporaryDirectory())
        let urlSessionConf = URLSessionConfiguration.background(withIdentifier: "\(Constants.bundleIdentifier).boilerplate-cache")
        
        let cachePlugin = NetworkDataCachingPlugin(configuration: urlSessionConf, with: cache)
        
        // Setup a custom plugin to use JWT with kuzzle service
        let accessToken = AccessTokenPlugin { () -> String in
            
            return NetworkManager.kuzzleJWT
        }
        
        // Setup behavior when we start and finish a network request
        let networkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: { (changeType, target) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = (changeType == .began)
            print("----")
            print("networkActivity: \(changeType), \(target)")
            print("----")
        })
        
        // Setup a logger for all Moya actions
        let networkLoggerPlugin = NetworkLoggerPlugin(verbose: true, cURL: true)
        
        // Initialize the kuzzle provider
        provider = MoyaProvider<KuzzleService>(plugins: [cachePlugin, accessToken, networkActivityPlugin, networkLoggerPlugin])
    }
    // MARK: - Init behaviors
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Delegates methods
    
}
