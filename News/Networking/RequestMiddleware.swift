//
//  RequestMiddleware.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-09.
//

import Foundation

class RequestMiddleware {
    static func request<T: Codable>(request: APIRequest, onCompletion: @escaping(T?) -> ()) {
        
        request.makeRequest{ (data: T? ,error) in
            if let err = error {
                switch err {
                
                case .noInternet:
                    break
                case .apiFailure:
                    break
                case .invalidResponse:
                    break
                case .decodingError:
                    break
                case .JSONSerializationError:
                    break
                case .badRequest:
                    break
                case .unauthorized:
                    print("unauthorised")
                    break
                case .forbidden:
                    break
                case .notFound:
                    break
                case .serverError:
                    break
                case .unknownError:
                    break
                }
            } else {
                onCompletion(data)
            }
            
        }
        
    }
}
