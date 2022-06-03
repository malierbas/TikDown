//
//  Networking.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import FirebaseFirestore
import Foundation
import UIKit

enum HostType {
    case alpha
    case beta
    case beta_beta
}

class ErrorModel: Codable {
    var status: ErrorStatus?
    var reason: String?
    
    enum ErrorStatus: String, Codable {
        case success, error
    }
}

 //MARK: - Result
 enum Result<T> {
     case success(T)
     case error(Error)
 }

 //MARK: - ResultCallback
 typealias ResultCallback<T> = (Result<T>) -> Void

 //MARK: - NetworkStackError
 enum NetworkStackError: Error {
     case authError
     case serializationError
     case invalidRequest
     case dataMissing
     case emailAlreadyTaken
     case invalidEmailOrPassword
     case requestNotSuccessful(errorMessage: String, statusCode: Int)
 }

 //MARK: - Webservice protocol
 protocol WebserviceProtocol {
     func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultCallback<T>)
 }

 //MARK: - NetworkManager
 final class NetworkManager: WebserviceProtocol {
     //: url session, parser
     private let urlSession: URLSession
     private let parser: Parser
     public static var shared = NetworkManager()
     //desc: firebase references
     private let constants = Firestore.firestore().collection("constants")
     
     //: constants
     enum Constants {
         static let hostType: HostType = .alpha
         
         static var host: String! {
             get {
                 switch hostType {
                     case .alpha:
                         return "tiktok-download-without-watermark.p.rapidapi.com"
                     case .beta:
                         return "tiktok-download-without-watermark.p.rapidapi.com"
                     case .beta_beta:
                         return "tiktok-download-without-watermark.p.rapidapi.com"
                 }
             }
         }
     }
     //: initialization
     init(urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
         self.urlSession = urlSession
         self.parser = Parser()
     }
     //: request
     func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultCallback<T>) {
         //: var get request

         guard let request = endpoint.request else {
             OperationQueue.main.addOperation { completion(.error(NetworkStackError.invalidRequest)) }
             return
         }
         //: log items
         print("----------------------------REQUEST:\nURL:\(request.description),\nHeaders: \(String(describing: request.allHTTPHeaderFields)),\nHttpBody: \(String(data: (request.httpBody ?? nil) ?? Data(), encoding: .utf8) ?? "nil.") \n----------------------------END")
         //: get task
         let task = urlSession.dataTask(with: request) { (data, response, error) in
             //: handle error
             if let error = error {
                 OperationQueue.main.addOperation { completion(.error(error)) }
                 return
             }
             //: get http response
             if let httpResponse = response as? HTTPURLResponse {
                 //: status code
                 let statusCode = httpResponse.statusCode
                 //: log status code
                 print("----------response status code: ", httpResponse.statusCode)
                 //: check status code
                 if statusCode >= 400 {
                     let errorModel: ErrorModel? = self.parser.getModel(from: data ?? Data())
                     OperationQueue.main.addOperation { completion(.error(NetworkStackError.requestNotSuccessful(errorMessage: errorModel?.reason ?? "Unknown error occured.", statusCode: statusCode))) }
                     return
                 }
                 //: check data exist
                 guard let data = data else {
                     OperationQueue.main.addOperation { completion(.error(NetworkStackError.dataMissing)) }
                     return
                 }
                 //: log data response
                 //
                 print("---------\(String(describing: endpoint.request?.url)),\nrespose data string = ", String(data: data, encoding: .utf8) ?? "nil.")
                 //: parse json and return
                 //: parse if data is not nil
                 self.parser.json(data: data, completion: completion)
             }
         }
         
         //: resume tast
         task.resume()
     }
     
     func getHashtags(
        callback: (([Hashtag]) -> Void)?
     ) {
         let hashtagsRef = constants.document("hashtags")
         hashtagsRef
             .getDocument { snapshot, error in
                 if (snapshot != nil && snapshot?.data() != nil && error == nil) {
                     if let data = snapshot?.data() {
                         do {
                             let decoder = JSONDecoder()
                             let decodedData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                             let hashtags = try decoder.decode(HashtagModel.self, from: decodedData)
                             callback?(hashtags.data ?? []) 
                         } catch let newError {
                             print("an decode error occured = ", newError.localizedDescription)
                         }
                     }
                 } else if let error = error {
                     print("an error occured!! = ", error.localizedDescription)
                 }
             }
     }
 }
 
 //MARK: - Parser
 struct Parser {
     let jsonDecoder = JSONDecoder()
     
     func json<T: Decodable>(data: Data, completion: @escaping ResultCallback<T>) {
         do {
             let responseModel = try jsonDecoder.decode(T.self, from: data)
             OperationQueue.main.addOperation {completion(.success(responseModel))}
         } catch let parseError {
             OperationQueue.main.addOperation {completion(.error(parseError))}
         }
     }
     
     func getModel<T: Decodable>(from data: Data) -> T? {
         return try? jsonDecoder.decode(T.self, from: data)
     }
 }

 //MARK: - EndPoint
 protocol Endpoint {
     var request: URLRequest? { get }
     var httpMethod: String { get }
     var queryItems: [URLQueryItem]? { get }
     var requestHeaders: [String: String]? { get }
     var requestBody: Data? { get }
     var scheme: String { get }
     var host: String { get }
 }

 extension Endpoint {
     func request(forPath path: String) -> URLRequest? {
         var urlComponents = URLComponents()
         urlComponents.scheme = scheme
         urlComponents.host = host
         urlComponents.path = path
         urlComponents.queryItems = queryItems
         guard let url = urlComponents.url else { return nil }
         var request = URLRequest(url: url)
         request.httpMethod = httpMethod
         request.httpBody = requestBody
         if let headers = requestHeaders {
             for (key, value) in headers {
                 request.setValue(value, forHTTPHeaderField: key)
             }
         }
         return request
     }
 }

 //MARK: - Endpoints
 enum Endpoints {
     case getVideoDetails(url: String)
     case searchHashtag(hashtag: String)
     case feed(region: String = "US")
 }

 //MARK: - Endpoints Extension
 extension Endpoints: Endpoint {
     //: scheme
     var scheme: String {
         return "https"
     }
     //: host
     var host: String {
         switch self {
         case .searchHashtag:
             return "tiktok-all-in-one.p.rapidapi.com"
         case .feed:
             return "tiktok-all-in-one.p.rapidapi.com"
         default:
             return NetworkManager.Constants.host
         }
     }
     //: request
     var request: URLRequest? {
         switch self {
         case .getVideoDetails:
             return request(forPath: "/analysis")
         case .searchHashtag:
             return request(forPath: "/search/video")
         case .feed:
             return request(forPath: "/feed")
         }
     }
     //: httpMethod
     var httpMethod: String {
         switch self {
         case .getVideoDetails:
             return "GET"
         case .searchHashtag:
             return "GET"
         case .feed:
             return "GET"
         }
     }
     //: queryItems
     var queryItems: [URLQueryItem]? {
         var defaultQueryItems: [URLQueryItem] = []
         switch self {
         case .getVideoDetails(let url):
             defaultQueryItems.append(URLQueryItem(name: "url", value: url))
         case .searchHashtag(let hashtag):
             defaultQueryItems.append(URLQueryItem(name: "query", value: hashtag))
             defaultQueryItems.append(URLQueryItem(name: "sort", value: "1"))
             defaultQueryItems.append(URLQueryItem(name: "time", value: "90"))
         case .feed:
             break
         }
         return defaultQueryItems
     }
     //: requestHeaders
     var requestHeaders: [String : String]? {
         var defaultHeaders: [String: String] = [:]
         
         switch self {
         case .getVideoDetails:
             defaultHeaders =  [
                "X-RapidAPI-Host": "tiktok-download-without-watermark.p.rapidapi.com",
                "X-RapidAPI-Key": "ab8fce17b9msh989ab5ff58c2060p188dcajsn8e1f70daf256"
             ]
             return defaultHeaders
         case .feed, .searchHashtag:
             defaultHeaders = [
                "X-RapidAPI-Host": "tiktok-all-in-one.p.rapidapi.com",
                "X-RapidAPI-Key": "ab8fce17b9msh989ab5ff58c2060p188dcajsn8e1f70daf256"
             ]
             
             return defaultHeaders
         }
     }
     //: request body
     var requestBody: Data? {
         switch self {
         case .getVideoDetails:
             return nil
         case .searchHashtag:
             return nil
         case .feed:
             return nil
         }
     }
 }
