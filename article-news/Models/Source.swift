//
//  Source.swift
//  article-news
//
//  Created by Roby Setiawan on 25/12/22.
//

import Foundation

struct Sources: Codable {
    public let sources: [Source]
}
// MARK: - Source
struct Source: Codable {
    public let sid: String?
    public let name: String
    public let category: String
    public let description: String
    public let isoLanguageCode: String
    public let country: String
    
    private enum CodingKeys: String, CodingKey {
        case sid = "id"
        case name, category, description, country
        case isoLanguageCode = "language"
    }
}
