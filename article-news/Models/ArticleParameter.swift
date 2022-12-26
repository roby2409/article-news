//
//  ArticleParameter.swift
//  article-news
//
//  Created by Roby Setiawan on 26/12/22.
//

import Foundation

struct ArticleParameters {
    var sources: String?
    var category: String?
    var country: String?
    
    init(sources: String? = nil, category: String? = nil, country: String? = nil) {
        self.sources = sources
        self.category = category
        self.country = country
    }
    
    func toLabel() -> String {
        var resultLabel = ""
        if let currentSources = sources{
            resultLabel += currentSources + " "
        }
        if let currentCategory = category{
            resultLabel += currentCategory + " "
        }
        if let currentCountry = country{
            resultLabel +=  currentCountry.formattedCountryDescription + " "
        }
        return resultLabel
    }
}
