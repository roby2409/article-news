//
//  ErrorApiFormation.swift
//  article-news
//
//  Created by Roby Setiawan on 25/12/22.
//

import Foundation

let ErrorApiFormation = errorApiFormation.instance

class errorApiFormation{
    static let instance = errorApiFormation()
    
    func createDomainMessage(_ statusCode: Int) -> NSError{
        if(statusCode == 400){
            return NSError(domain: "Bad Request. The request was unacceptable, often due to a missing or misconfigured parameter.", code: statusCode)
        }else if(statusCode == 401){
            return NSError(domain: "return Unauthorized. Your API key was missing from the request, or wasn't correct.", code: statusCode)
        }else if(statusCode == 404){
            return NSError(domain: "url not found.", code: statusCode)
        }else if(statusCode == 429){
            return NSError(domain: "Too Many Requests. You made too many requests within a window of time and have been rate limited. Back off for a while.", code: statusCode)
        }else if(statusCode == 500){
            return NSError(domain: "Server Error. Something went wrong on our side.", code: statusCode)
        }else if(statusCode == 1001){
            return NSError(domain: "Failed decode with model.", code: statusCode)
        }else{
            return NSError(domain: "Something went wrong.", code: statusCode)
        }
        
    }
}
