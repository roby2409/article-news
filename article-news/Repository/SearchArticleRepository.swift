//
//  SearchArticleRepository.swift
//  article-news
//
//  Created by Roby Setiawan on 26/12/22.
//

import Foundation

class SearchArticleRepository{
    static let shared = SearchArticleRepository()
    
    private let host = APIService.sharedInstance.defaultService
    
    
    // MARK: EndPoints for Top Headlines of News Api
    ///*
    /// in the newsapi documentation, we have to set one of the following required parameters and try again: q, qInTitle, sources, domains
    func processingEndpointTopHeadLines(articleRequestParams: ArticleParameters, page: Int, completion: @escaping (Result<Articles, Error>) -> Void){
        // MARK: CONDITION TOP HEADLINES
        /// catatan
        /// if there is a category and country, the parameter url cannot be combined with sources
        /// from his condition there are only 2 choices of partners
        /// 1. source alone, 2. country and counter
        
        
        let queryItemsSource = [
            URLQueryItem(name: "sortBy", value: "publishedAt"),
            URLQueryItem(name: "sources", value: articleRequestParams.sources),
            URLQueryItem(name: "pageSize", value: "\(10)"),
            URLQueryItem(name: "page", value: "\(page)"),
        ]
        
        let queryItemsCategoryOrCountry = [
            URLQueryItem(name: "category", value: articleRequestParams.category),
            URLQueryItem(name: "country", value: articleRequestParams.country),
            URLQueryItem(name: "pageSize", value: "\(10)"),
            URLQueryItem(name: "page", value: "\(page)"),
        ]
        var urlComps = URLComponents(string: host + "/top-headlines")!
        
        if(articleRequestParams.category != nil || articleRequestParams.country != nil){
            urlComps.queryItems = queryItemsCategoryOrCountry
        }else{
            urlComps.queryItems = queryItemsSource
        }
        
        let result = urlComps.url!
        APIService.sharedInstance.apiToGetNews(result){ (articlesResult, errorCode) in
            if let newsResult = articlesResult{
                completion(.success(newsResult))
            }  else {
                completion(.failure(ErrorApiFormation.createDomainMessage(errorCode)))
            }
        }
    }
    
    
    // MARK: EndPoints for Everything of News Api
    ///*
    /// in the newsapi documentation, we have to set one of the following required parameters and try again: q, qInTitle, sources, domains
    func processingEndpointEverything(q: String?, completion: @escaping (Result<Articles, Error>) -> Void){
        let queryItems = [URLQueryItem(name: "q", value: q)]
        var urlComps = URLComponents(string: host + "/everything")!
        urlComps.queryItems = queryItems
        let result = urlComps.url!
        APIService.sharedInstance.apiToGetNews(result){ (articlesResult, errorCode) in
            if let newsResult = articlesResult{
                completion(.success(newsResult))
            }  else {
                completion(.failure(ErrorApiFormation.createDomainMessage(errorCode)))
            }
        }
    }
}
