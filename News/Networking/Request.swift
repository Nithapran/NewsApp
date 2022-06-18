//
//  Request.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-05.
//

import Foundation

enum NetworkRequestError: Error {
    case noInternet
    case apiFailure
    case invalidResponse
    case decodingError
    case JSONSerializationError
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unknownError
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

struct NetWorkConfiguration {
    var baseURL: String
    var auth: () -> String?
}

public typealias Parameters = [String : Any]
public typealias HTTPHeaderType = [String: String?]

protocol APIRequest {
    var netWorkConfiguration: NetWorkConfiguration {get}
    var path: APIPath {get}
    var method: HTTPMethod {get}
    var parameters: Parameters? {get}
    var urlQueryParameters: Parameters? {get}
    
    func method(_ method: HTTPMethod) -> APIRequest
    func path(_ path: APIPath) -> APIRequest
    func parameters(_ parameters: Parameters) -> APIRequest
    func urlQueryParameters(_ parameters: Parameters) -> APIRequest
    func appendHeader(key: String, value: String?) -> APIRequest
    
    func makeRequest<T: Codable>(onCompletion: @escaping(T?, NetworkRequestError?) -> ())
}

extension APIRequest {
    func toUrlRequest(data: APIRequest) throws -> URLRequest  {
        var url = URL(string: data.netWorkConfiguration.baseURL)!
        url.appendPathComponent(data.path.toString)
        
        
        
        
        
        if let parameters = data.urlQueryParameters {
            do {
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
                var queryIems: [URLQueryItem] = []
                
                for param in parameters {
                    queryIems.append(URLQueryItem(name: param.key, value: param.value as? String))
                }
                
                urlComponents?.queryItems = queryIems
                url = (urlComponents?.url)!
            } catch {
                throw NetworkRequestError.JSONSerializationError
            }
        }

        
        
        var request = URLRequest(url: url)
        
        request.httpMethod = data.method.rawValue

        if let parameters = data.parameters {
            do {
                let httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = httpBody
                
            } catch {
                throw NetworkRequestError.JSONSerializationError
            }
        }
        
        if path.requireAuthentication {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(data.netWorkConfiguration.auth() ?? "")", forHTTPHeaderField: "Authorization")
        }

        return request
    }
    
    func httpError(_ statusCode: Int) -> NetworkRequestError {
            switch statusCode {
            case 400: return .badRequest
            case 401: return .unauthorized
            case 403: return .forbidden
            case 404: return .notFound
            case 500: return .serverError
            default: return .unknownError
            }
        }
}


class RequestBuilder: APIRequest {
    
    var parameters: Parameters?
    
    var urlQueryParameters: Parameters?
    
    var netWorkConfiguration: NetWorkConfiguration
    
    var path: APIPath = .empty
    
    var method: HTTPMethod = .get
    
    
    init(netWorkConfiguration: NetWorkConfiguration) {
        self.netWorkConfiguration = netWorkConfiguration
        
    }
    
    func method(_ method: HTTPMethod) -> APIRequest {
        self.method = method
        return self
    }
    
    func path(_ path: APIPath) -> APIRequest {
        self.path = path
        return self
    }
    
    
    
    func parameters(_ parameters: Parameters) -> APIRequest {
        self.parameters = parameters
        return self
    }
    
    func urlQueryParameters(_ parameters: Parameters) -> APIRequest {
        self.urlQueryParameters = parameters
        return self
    }
    
    func appendHeader(key: String, value: String?) -> APIRequest {
        return self
    }
    
    func makeRequest<T: Codable>(onCompletion: @escaping(T?, NetworkRequestError?) -> ()) {
        
        do {
            let request =  try self.toUrlRequest(data: self)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil, let responseData = data else {
                    onCompletion(nil, NetworkRequestError.apiFailure)
                    return
                    
                }
                
                if let response = response as? HTTPURLResponse,
                                  !(200...299).contains(response.statusCode) {
                    onCompletion(nil, self.httpError(response.statusCode))
                               }
                do {
                    let responseModel =  try JSONDecoder().decode(T.self,from: responseData)
                    onCompletion(responseModel, nil)
                } catch {
                    print(error)
                }
                
            }.resume()
        } catch {
            onCompletion(nil, error as? NetworkRequestError)
        }
            
        
        
        
    }
}
