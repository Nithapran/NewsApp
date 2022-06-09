//
//  RequestService.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-06.
//

import Foundation

class RequestService: APIClient {
    func getAllRequests() {
        let request = getBuilder().path(.getAllRequests).method(.get)
        RequestMiddleware.request(request: request){ (data: ResponseModel<[Request]>?) in
            
        }
    }
    
    func createRequest() {
        let request = getBuilder().path(.getAllRequests).method(.post).parameters(
            [
                "latitude": 43.755672,
                    "longtitude": -79.360117,
                    "address": "1869 Leslie St, North York, ON M3B 2M3",
                    "haveJumperCable": false,
                    "phoneNumber": "6478047139"
            ]
        )
        RequestMiddleware.request(request: request){ (data: ResponseModel<Request>?) in
            
        }
    }
}

class ResponseModel<T: Codable>: Codable {
    var statusCode: Int?
    var message: String?
    var data: T?

}

//
//  Request.swift
//  Jumpstart
//
//  Created by Nithaparan Francis on 2022-03-11.
//

import Foundation
import SwiftUI
import CoreLocation

struct Request: Hashable, Codable {
    var createdBy: User
    var acceptedBy: User?
    var _id: String
    var address: String
    var phoneNumber: String
    var coordinate: [Double]
    var status: String
    var haveJumperCable: Bool
    
    enum CodingKeys: String, CodingKey {
            case createdBy
            case acceptedBy
            case _id
            case address
            case phoneNumber
            case coordinate
            case status
            case haveJumperCable
        }
    
    
    init(createdBy: User, acceptedBy: User?, _id: String, address: String, phoneNumber: String, coordinate: [Double], status: String, haveJumperCable: Bool) {
        self.createdBy = createdBy
        self.acceptedBy = acceptedBy
        self._id = _id
        self.address = address
        self.phoneNumber = phoneNumber
        self.coordinate = coordinate
        self.status = status
        self.haveJumperCable = haveJumperCable
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.createdBy = try values.decode(User.self, forKey: .createdBy)
        self._id = try values.decode(String.self, forKey: ._id)
        self.address = try values.decode(String.self, forKey: .address)
        self.phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
        self.coordinate = try values.decode(Array.self, forKey: .coordinate)
        self.address = try values.decode(String.self, forKey: .address)
        self.status = try values.decode(String.self, forKey: .status)
        self.haveJumperCable = try values.decode(Bool.self, forKey: .haveJumperCable)
        if values.contains(.acceptedBy) {
            self.acceptedBy = try values.decode(User.self, forKey: .acceptedBy)
        } else {
            self.acceptedBy = nil
        }
    }
    func getStatus() -> String {
        switch self.status {
        case "CREATED":
            return "Created"
        case "ACCEPTED":
            return "Accepted"
        case "CANCELLED":
            return "Cancelled"
        case "COMPLETED":
            return "Completed"
        default:
            return ""
        }
    }
    
    static func getDumpRequest() -> Request {
        return Request(createdBy: User.getDumpUser(), acceptedBy: User.getDumpUser(), _id: "002", address: "1869 Leslie St, North York, ON M3B 2M3", phoneNumber: "6478675645", coordinate: [43.755672,-79.360117], status: "ACCEPTED", haveJumperCable: false)
    }
    
    
}

struct User: Hashable, Codable {
    var _id: String
    var name: String
    var email: String
    var lastLocation: [Double?]
    var token: String?
    var refreshToken: String?
    var phoneNumber: String?
    var completedRequests: Int
    var ownRequests: Int
    
    enum CodingKeys: String, CodingKey {
            case _id
            case name
            case email
            case lastLocation
            case token
            case refreshToken
            case phoneNumber
            case completedRequests
            case ownRequests
        }
    
    init (_id: String, name: String, email: String, lastLocation: [Double?], token: String?, refreshToken: String?,phoneNumber: String?, completedRequests: Int, ownRequests: Int) {
        self._id = _id
        self.name = name
        self.email = email
        self.lastLocation = lastLocation
        self.token = token
        self.refreshToken = refreshToken
        self.phoneNumber = phoneNumber
        self.completedRequests = completedRequests
        self.ownRequests = ownRequests
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try values.decode(String.self, forKey: ._id)
        self.name = try values.decode(String.self, forKey: .name)
        self.email = try values.decode(String.self, forKey: .email)
        self.lastLocation = try values.decode(Array.self, forKey: .lastLocation)
        
        
        
        if values.contains(.phoneNumber) {
            self.phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
        } else {
            self.phoneNumber = nil
        }
        
        if values.contains(.token) {
            self.token = try values.decode(String.self, forKey: .token)
        } else {
            self.token = nil
        }
        if values.contains(.refreshToken) {
            self.refreshToken = try values.decode(String.self, forKey: .refreshToken)
        } else {
            self.refreshToken = nil
        }
        
        
        if values.contains(.completedRequests) {
            self.completedRequests = try values.decode(Int.self, forKey: .completedRequests)
        } else {
            self.completedRequests = 0
        }
        if values.contains(.ownRequests) {
            self.ownRequests = try values.decode(Int.self, forKey: .ownRequests)
        } else {
            self.ownRequests = 0
        }
    }
    
    static func getDumpUser() -> User {
        return User(_id: "001", name: "Nithaparan Francis", email: "nithaparan@eample.com", lastLocation: [35.7020691,139.7753265], token: "", refreshToken: "", phoneNumber: "6476785634", completedRequests: 5, ownRequests: 7)
    }
}


