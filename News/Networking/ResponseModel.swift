//
//  ResponseModel.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-18.
//

import Foundation

class ResponseModel<T: Codable>: Codable {
    var totalResults: Int?
    var status: String?
    var articles: T?

}
