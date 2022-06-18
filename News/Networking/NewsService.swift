//
//  NewsService.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-06.
//

import Foundation

class NewsService: APIClient {
    func getTopHeadLines(queryParams: [String: Any],  onCompletion: @escaping([News]?) -> ()) {
        let request = getBuilder().path(.topHeadLines).method(.get).urlQueryParameters(queryParams)
        RequestMiddleware.request(request: request){ (data: ResponseModel<[News]>?) in
            onCompletion(data?.articles)
        }
        
    }
    
    
}



