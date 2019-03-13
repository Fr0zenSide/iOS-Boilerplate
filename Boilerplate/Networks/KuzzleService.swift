//
//  KuzzleService.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 30/01/2019.
//  Copyright © 2019 Jeoffrey Thirot. All rights reserved.
//

import UIKit
import Moya


enum KuzzleService {
    case hello
    case login(username: String, password: String)
}

extension KuzzleService: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Constants.kuzzleServerURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    var path: String {
        switch self {
        case .hello:
            return "/"
        case .login(_, _):
            return "/_login/local"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .hello:
            return .get
        case .login(_, _):
            return .get
        }
    }
    
    var parameters: [String: Any] {
        switch self {
//        case .serverDetails, .content, .listInstallationDevices, .detailRFIDTag(_), .downloadMoyaWebContent, .translations:
//            return nil
        case .hello:
            return ["pretty": true]
        case .login(let username, let password):
            return ["username": username, "password": password]
//            return ["controller": "auth", "action": "login", "strategy": "local", "body": ["username": username, "password": password]]
            /*
            {
                "controller": "auth",
                "action": "login",
                "strategy": "local",
                "body": {
                    "username": "<my_username>",
                    "password": "<my_password>"
                }
            }
            */
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .hello:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
//    var task: Moya.Task {
////        switch self {
////        case .hello:
////            return .hello
////        case .createInstallationMedia(_, _, _, let media, _, _, _, _):
////            let mimeType = _mimeTypeForPath(url: media)
////            let fileName = media.lastPathComponent
////            let multipartFormData = MultipartFormData(provider: .file(media), name: "media", fileName: fileName, mimeType: mimeType)
////            return .upload(.multipart([multipartFormData]))
////        case .downloadMoyaWebContent:
////            return .download(.request(DefaultDownloadDestination))
////        default:
//        return .request
////        }
//    }
    var task: Task {
        switch self {
        case .hello: // Send no parameters
            return .requestPlain
        default:
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
//        case let .updateUser(_, firstName, lastName):  // Always sends parameters in URL, regardless of which HTTP method is used
//            return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: URLEncoding.queryString)
//        case let .createUser(firstName, lastName): // Always send parameters as JSON in request body
//            return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .hello:
            return _getLocalJson(name: "hello")
        case .login(let username):
            return _getLocalJson(name: "login-\(username)")
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    public func clearCache(provider: MoyaProvider<KuzzleService>, urlRequests: [URLRequest] = []) {
        guard let urlCache = provider.manager.session.configuration.urlCache else { return }
        if urlRequests.isEmpty {
            urlCache.removeAllCachedResponses()
        } else {
            urlRequests.forEach { urlCache.removeCachedResponse(for: $0) }
        }
    }
    
    private func _getLocalJson(name:String!) -> Data! {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
        /*
        let path = Bundle.main.path(forResource: name, ofType: "json")
        do {
            let json: Data = try Data(contentsOf: NSURL.fileURL(withPath:path!))
            return json
        } catch {
            return "{}".utf8EncodedData
        }
        */
    }
//    
//    private func _error(name:String!) {
//        DDLogDebug("Warning! You have an error with the api of MEP (\(name))")
//    }
//    
//    private func _mimeTypeForPath(url: URL) -> String {
//        let pathExtension = url.pathExtension
//        
//        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
//            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
//                return mimetype as String
//            }
//        }
//        return "application/octet-stream"
//    }
//    
//    private let DefaultDownloadDestination: DownloadDestination = { temporaryURL, response in
//        let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        
//        if !directoryURLs.isEmpty {
//            return (directoryURLs[0].appendingPathComponent(response.suggestedFilename!), [])
//        }
//        
//        return (temporaryURL, [])
//    }
    
}

extension KuzzleService: CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
        case .hello:
            return .returnCacheDataElseLoad
        default:
            return .useProtocolCachePolicy
        }
    }
}

extension KuzzleService: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType {
        switch self {
        case .hello:
            return .bearer
        default:
            return .none
        }
    }
}
