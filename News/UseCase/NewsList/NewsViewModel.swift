//
//  NewsViewModel.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-09.
//

import Foundation
import RxSwift
import RxCocoa

class NewsViewModel {
    
    let appliedFilter = PublishSubject<Countries?>()
    
    let obsevedNews = PublishSubject<[News]>()
    
    private let bag = DisposeBag()
    
    var news: [News] = []
    
    var searchText: String? {
        didSet {
            
            guard let text = searchText else {
                self.obsevedNews.onNext(self.news)
                return
            }
        
            if text == "" {
                self.obsevedNews.onNext(self.news)
                return
            }
            let aa = self.news.filter {
                $0.title!.lowercased().contains(text.lowercased())
            }
            self.obsevedNews.onNext(aa)
        }
    }
    
    func fetchNews(selectedCountry: String = "CA") {
        
        let queryParams = [
            "country": selectedCountry,
            "apiKey": "9e9d4bdb2c1d4d9c99488b8f32079b79"
        ]
        App.service.newsService.getTopHeadLines(queryParams: queryParams) {
            newss in
            self.news = newss ?? []
            self.obsevedNews.onNext(newss!)
        }
        
        
        
    }
}
