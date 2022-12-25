//
//  Articles.swift
//  article-news
//
//  Created by Roby Setiawan on 23/12/22.
//

import Foundation

// MARK: - Article
struct Articles: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleElement]
}

// MARK: - ArticleElement
struct ArticleElement: Codable {
    let source: Source
    let author: String?
    let title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}


