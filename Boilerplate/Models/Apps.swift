//
//  Apps.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 07/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import Foundation

// todo: Need to externalize Metadata models if I need to use it in the others routes
class Metadata: Codable {
    let request: Request
    let content: MetadataContent
    
    init(request: Request, content: MetadataContent) {
        self.request = request
        self.content = content
    }
}

class MetadataContent: Codable {
    let size, totalSize: Int?
    let resultIDS: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case size
        case totalSize = "total_size"
        case resultIDS = "result_ids"
    }
    
    init(size: Int?, totalSize: Int?, resultIDS: [Int]?) {
        self.size = size ?? 0
        self.totalSize = totalSize ?? 0
        self.resultIDS = resultIDS ?? []
    }
}

class Request: Codable {
    let path, store: String
    let params: Params
    let performedAt: String
    
    enum CodingKeys: String, CodingKey {
        case path, store, params
        case performedAt = "performed_at"
    }
    
    init(path: String, store: String, params: Params, performedAt: String) {
        self.path = path
        self.store = store
        self.params = params
        self.performedAt = performedAt
    }
}

class Params: Codable {
    let term: String?
    let country, language: String
    let device: Device
    let num: Int?
    let format: String
    
    init(term: String?, country: String, language: String, device: Device, num: Int?, format: String) {
        self.term = term ?? ""
        self.country = country
        self.language = language
        self.device = device
        self.num = num ?? 0
        self.format = format
    }
}

class Apps: Codable, Serializable {
    // MARK: - Variables
    // Private variables
    
    static private var _cacheKeyPaternTop = "Apps.info.top"
    static private var _netEngine = NetworkEngine()
    
    private enum CodingKeys: String, CodingKey {
        case content, metadata
    }
    
    // Public variables
    
    let content: [App]
    let metadata: Metadata?
    
    // MARK: - Getter & Setter methods
    
    // MARK: - Constructors
    
    /**
     Method to create the models Apps
     
     - Parameter content: array of app object
     - Parameter metadata: object which contain all metadata of the api for this call
     */
    init(content: [App], metadata: Metadata? = nil) {
        self.content = content
        self.metadata = metadata
    }
    
    // MARK: - Init behaviors
    
    required init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.content = try values.decode([App].self, forKey: .content)
            self.metadata = try values.decode(Metadata.self, forKey: .metadata)
        } catch {
            fatalError("Error! When you want to decode your model: \(AbstractModel.modelName)")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(content, forKey: .content)
            try container.encode(metadata, forKey: .metadata)
        } catch {
            fatalError("Error! When you want to encode your model: \(type(of: self)) > \(self)")
        }
    }
    
    // MARK: - Public methods
    
    /**
     Method to get the app list of the apps
     
     - Parameter complete: closure call when the script has finished to get all data
     */
    static func getTopAppsList(complete: @escaping ((_ result: Apps?) -> Void)) {
        // Check if the data are already on my cache
        if let json = _netEngine.getToCache(from: "\(_cacheKeyPaternTop)"),
            let jsonData = json.data(using: .utf8),
            let apps = AbstractModel.decodeTypedObject(type: Apps.self, data: jsonData) {
            print("Apps list from cache: \(apps)")
            complete(apps)
        } else {
            // Get my data on server
            let params: [String: Any] = ["id": "-", "country": Constants.country, "language": Constants.locale]
            let api: NetworkEngine.APIKeyEndPoint = .famousApp
            _netEngine.getRessource(for: api, with: params, complete: { (result: NetworkEngine.Result) in
                switch result {
                case .success(let response):
                    print("Success 🙂")
                    if let data = response?["data"] as? Data {
                        let apps = AbstractModel.decodeTypedObject(type: Apps.self, data: data)
                        print("List of apps: \(String(describing: apps))")
                        // todo: Add cache behavior directly in network layer later
                        if let json = apps?.JSONString() {
                            _netEngine.addToCache(for: _cacheKeyPaternTop, data: json)
                        }
                        complete(apps)
                    }
                case .error(let message):
                    print("Ouch 🤕\n\(message)")
                    complete(nil)
                }
            })
        }
    }
    
    // MARK: - Private methods
    
    // MARK: - Delegates methods
}
