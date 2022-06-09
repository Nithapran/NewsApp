//
//  Request.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-05.
//

import Foundation

enum NetworkError: Error {
    case noInternet
    case apiFailure
    case invalidResponse
    case decodingError
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum AuthHeader {
    
    case bearer(value: String)
    case custom(customHeader: String,value: String)
    
    var header: HTTPHeaderType {
        switch self {
        case .bearer(let value):
            return ["Authorization" : "Bearer"+value]
        case .custom(let customHeader,let value):
            return ["Authorization" : customHeader+value]
        }
    }
    
}

public typealias Parameters = [String : Any]
public typealias HTTPHeaderType = [String: String?]

protocol APIRequest {
    var netWorkConfiguration: NetWorkConfiguration {get}
    var path: APIPath {get}
    var method: HTTPMethod {get}
    var parameters: Parameters? {get}
    func method(_ method: HTTPMethod) -> APIRequest
    func path(_ path: APIPath) -> APIRequest
    func parameters(_ parameters: Parameters) -> APIRequest
   
    func appendHeader(key: String, value: String?) -> APIRequest
    func makeRequest<T: Codable>(onCompletion: @escaping(T?, NetworkError?) -> ())
}

extension APIRequest {
    func toUrlRequest(data: APIRequest) -> URLRequest {
        var url = URL(string: data.netWorkConfiguration.baseURL)!
        url.appendPathComponent(data.path.toString)
        var request = URLRequest(url: url)
        request.httpMethod = data.method.rawValue

        if let parameters = data.parameters {
            do {
                let httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = httpBody
                
            } catch {
                
            }
        }

        return request
    }
}


class RequestBuilder: APIRequest {
    
    var parameters: Parameters?
    
    var netWorkConfiguration: NetWorkConfiguration
    
    var path: APIPath = .empty
    
    var method: HTTPMethod = .get
    
    
    init(netWorkConfiguration: NetWorkConfiguration) {
        self.netWorkConfiguration = netWorkConfiguration
        
    }
    
//    init(_ baseURL: String,_ path: APIPath) {
//        self.path = path
//        var url = URL(string: baseURL)!
//        url.appendPathComponent(path.toString)
//        request = URLRequest(url: url)
//        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        if path.requireAuthentication {
//            request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MjhhOTJkZDcwN2U5NzYwYjk0YjZhNWUiLCJpYXQiOjE2NTMyNDg3MzMsImV4cCI6MTY4NDM1MjczM30.h8Z-nGVr8166YTYOkwrC1p9WEmeFG5o-pEIpln9MmAQ", forHTTPHeaderField: "Authorization")
//        }
//
//
//
//    }
    
    func method(_ method: HTTPMethod) -> APIRequest {
        self.method = method
        return self
    }
    
    func path(_ path: APIPath) -> APIRequest {
        self.path = path
        return self
    }
    
    
    
    func parameters(_ parameters: Parameters) -> APIRequest {
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
//                return self
//            }
//            request.httpBody = httpBody
        self.parameters = parameters
        return self
    }
    
    
    
    func appendHeader(key: String, value: String?) -> APIRequest {
        return self
    }
    
    func makeRequest<T: Codable>(onCompletion: @escaping(T?, NetworkError?) -> ()) {
        URLSession.shared.dataTask(with: self.toUrlRequest(data: self)) { data, response, error in
            guard error == nil, let responseData = data else { onCompletion(nil, NetworkError.apiFailure) ; return }
            do {
                let responseModel =  try JSONDecoder().decode(T.self,from: responseData)
                onCompletion(responseModel, nil)
            } catch {
                print(error)
            }
            
        }.resume()
    }
}
