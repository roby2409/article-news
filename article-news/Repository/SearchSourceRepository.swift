//
//  SearchArticleRepository.swift
//  article-news
//
//  Created by Roby Setiawan on 25/12/22.
//

import Foundation

class SearchSourceRepository{
    static let shared = SearchSourceRepository()
    
    private let host = APIService.sharedInstance.defaultService
    func searchSources(sourceRequestParams: SourceParameters, completion: @escaping (Result<Sources, Error>) -> Void){
        let queryItems = [URLQueryItem(name: "category", value: sourceRequestParams.category),
                          URLQueryItem(name: "language", value: sourceRequestParams.language),
                                               URLQueryItem(name: "country", value: sourceRequestParams.country)]
        var urlComps = URLComponents(string: host + "/sources")!
        urlComps.queryItems = queryItems
        let result = urlComps.url!
        print("currentUrl  \(result)")
        APIService.sharedInstance.apiToGetSources(result){ (articlesResult, errorCode) in
            if let newsResult = articlesResult{
                completion(.success(newsResult))
            }  else {
                completion(.failure(ErrorApiFormation.createDomainMessage(errorCode)))
            }
        }
        
        
        
    }

}
