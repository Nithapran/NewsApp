//
//  APIClient.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-08.
//

import Foundation


class APIClient {
    var netWorkConfiguration: NetWorkConfiguration
    
    init() {
        var baseURL = ""
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                        if let dic = NSDictionary(contentsOfFile: path) {
                            baseURL = dic["BASE_URL"] as! String
                        }
                    }
        self.netWorkConfiguration = NetWorkConfiguration(baseURL: baseURL, auth: {return App.storage.authStore.getToken()})
        
    }
    
    func getBuilder() -> RequestBuilder {
        let req = RequestBuilder(netWorkConfiguration: netWorkConfiguration)
        return req
    }
}
