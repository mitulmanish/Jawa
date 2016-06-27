//
//  APIClient.swift
//  Jawa
//
//  Created by Mitul Manish on 26/06/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
public let MITNetworkingErrorDomain = "com.mitulmanish.Jawa.NetworkingError"
public let MissingHTTPResponseError = 11
public let JsonParsingError = 12

typealias JSON = [String : AnyObject]
typealias JSONTask = NSURLSessionDataTask
typealias JSONTaskCompletion = (JSON?, NSHTTPURLResponse?, NSError?) -> Void


enum APIResult<T> {
    case Success(T)
    case Failure(ErrorType)
}

protocol APIEndPoint {
    var baseUrl: NSURL { get }
    var path: String { get }
    var request: NSURLRequest { get }
}

protocol JSONDecodable {
    init?(JSON: [String : AnyObject])
}

protocol APIClient {
    var configuration: NSURLSessionConfiguration { get }
    var session: NSURLSession { get }
    
    func JSONTaskWithRequest(request: NSURLRequest, completionHandler: JSONTaskCompletion) -> JSONTask
    func fetch<T: JSONDecodable>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult<T> -> Void)
}

extension APIClient {
    
    func JSONTaskWithRequest(request: NSURLRequest, completionHandler completion: JSONTaskCompletion) -> JSONTask {
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard let HTTPResponse = response as? NSHTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                
                let error = NSError(domain: MITNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completion(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String : AnyObject]
                        completion(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completion(nil, HTTPResponse, error)
                    }
                default: print("Received HTTP Response: \(HTTPResponse.statusCode) - not handled")
                }
            }
        }
        
        return task
    }
    
    func fetch<T>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult<T> -> Void) {
        let task = JSONTaskWithRequest(request) { (json, response, error) in
            guard let json = json else {
                if let error = error {
                    completion(.Failure(error))
                }
                return
            }
        
        
            if let jsonData = parse(json) {
                completion(.Success(jsonData))
            } else {
                let error = NSError(domain: MITNetworkingErrorDomain, code: JsonParsingError, userInfo: nil)
                completion(.Failure(error))
            }
        }
        task.resume()
    }
    
}
