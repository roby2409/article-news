//
//  SourceParameter.swift
//  article-news
//
//  Created by Roby Setiawan on 25/12/22.
//

import Foundation

struct SourceParameters {
    var category: String?
    let language: String?
    let country: String?
    let q: String?
    
    init(category: String? = nil, language: String? = nil, country: String? = nil, q: String? = nil) {
        self.category = category
        self.language = language
        self.country = country
        self.q = q
    }
}
