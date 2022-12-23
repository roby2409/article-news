//
//  api_services.swift
//  article-news
//
//  Created by Roby Setiawan on 23/12/22.
//

import Foundation


class APIService :  NSObject {
    
    private let defaultService = NewsApi.BASE_URL + NewsApi.version
    
    func apiToGetNews(route: String, completionHandler : @escaping (_ response:Articles?, _ errorCode: Int)-> Void) {
        guard let apiKey: String = AppInsightsArticleNewsWrapper().generateAklInside()else{
            completionHandler(nil, 1004)
            return
        }
        guard let urlRequest = URL(string: defaultService + "/" + route) else {
            completionHandler(nil, 404)
            return
        }
        var request = URLRequest(url: urlRequest)
        request.timeoutInterval = 12
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil, let receivedData = data, let httpResponse = response as? HTTPURLResponse {
                guard  (200 ..< 299) ~= httpResponse.statusCode else {
                    completionHandler(nil, httpResponse.statusCode)
                    return
                }
                guard let mappedResponse = try? JSONDecoder().decode(Articles.self, from: receivedData) else {
                    completionHandler(nil, 1001)
                    return
                }
                completionHandler(mappedResponse, httpResponse.statusCode)
            }else{
                let getStatusCode = (error as NSError?)?.code
                completionHandler(nil, getStatusCode ?? 500)
            }
            
        })
        task.resume()
    }
    
}