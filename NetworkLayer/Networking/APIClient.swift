//
//  APIClient.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-08.
//

import Foundation

struct NetWorkConfiguration {
    var baseURL: String
    var auth: () -> String?
}

class APIClient {
    var netWorkConfiguration: NetWorkConfiguration
    
    init() {
        self.netWorkConfiguration = NetWorkConfiguration(baseURL: "http://127.0.0.1:3001/", auth: {return ""})
        
    }
    
    func getBuilder() -> RequestBuilder {
        let req = RequestBuilder(netWorkConfiguration: netWorkConfiguration)
        return req
    }
}
