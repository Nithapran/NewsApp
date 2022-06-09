//
//  APIPath.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-06.
//

import Foundation

public enum APIPath: Equatable {
    case getAllRequests
    case authRefresh
    case empty
    
    var requireAuthentication: Bool {
        switch self {
        case .getAllRequests:
            return true
        default:
            return false
        }
    }
    
    var toString: String {
        switch self {
        case .getAllRequests: return "api/request/requests/"
        case .authRefresh: return "order-traveler-api/api/jwt/refresh_token"
        case .empty: return ""
        }
    }
}
