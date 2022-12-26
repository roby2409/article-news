//
//  api_services.swift
//  article-news
//
//  Created by Roby Setiawan on 23/12/22.
//

import Foundation


class APIService :  NSObject {
    
    static let sharedInstance: APIService = {
        
        let instance = APIService()
        return instance
    }()
    
    func getSourceNewsLogoUrl(source: String) -> String {
        let sourceLogoUrl = "https://res.cloudinary.com/news-logos/image/upload/v1557987666/\(source).png"
        return sourceLogoUrl
    }
    
    public let defaultService = NewsApi.BASE_URL + NewsApi.version
    
    func apiToGetNews(_ url: URL, completionHandler : @escaping (_ response:Articles?, _ errorCode: Int)-> Void) {
        guard let apiKey: String = AppInsightsArticleNewsWrapper().generateAklInside()else{
            completionHandler(nil, 1002)
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 18
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
                do{
                    let mappedResponse = try JSONDecoder().decode(Articles.self, from: receivedData)
                    completionHandler(mappedResponse, httpResponse.statusCode)
                }catch let error{
                    print("error: \(error)")
                    completionHandler(nil, 1001)
                }
                
            }else{
                let getStatusCode = (error as NSError?)?.code
                completionHandler(nil, getStatusCode ?? 500)
            }
            
        })
        task.resume()
    }
    
    
    func apiToGetSources(_ url: URL, completionHandler : @escaping (_ response:Sources?, _ errorCode: Int)-> Void) {
        guard let apiKey: String = AppInsightsArticleNewsWrapper().generateAklInside()else{
            completionHandler(nil, 1002)
            return
        }
        var request = URLRequest(url: url)
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
                guard let mappedResponse = try? JSONDecoder().decode(Sources.self, from: receivedData) else {
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
