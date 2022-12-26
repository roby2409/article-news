//
//  SourceArticleNewsModels.swift
//  article-news
//
//  Created by Roby Setiawan on 23/12/22.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class SourceArticleNewsModels{
    private let searchArticleRepository = SearchSourceRepository.shared
    private let disposeBag   = DisposeBag()
    var itemSources          = BehaviorRelay<[Source]>(value: [])
    var categories           = PublishRelay<[String]>()
    var countries            = PublishRelay<[String?]>()
    var languages            = PublishRelay<[String?]>()
    var imageDownloaded      = PublishRelay<(Int, UIImage?)>()
    
    
    /// Loading images from given api
    func fetchSources(sourceParameters: SourceParameters, fetchFirst: Bool) {
        var resultSourceParameter = sourceParameters
        if(fetchFirst){
            resultSourceParameter.category = nil
        }
        self.searchArticleRepository.searchSources(sourceRequestParams: resultSourceParameter) { [weak self] response in
            switch response {
            case .failure(let e):
                print("error", e.localizedDescription)
                self?.itemSources.accept([])
                
            case .success(let data):
                var filteredSourceItems = data.sources
                if let currentCategory = sourceParameters.category{
                    let searchResults = data.sources.filter { $0.category == currentCategory}
                    
                    filteredSourceItems = searchResults
                }
                
                self?.itemSources.accept(filteredSourceItems)
                
                
                // ambil semua data dari url path sources
                if(fetchFirst){
                    fetchCategories()
                    fetchCountry(dataSources: data.sources)
                    fetchLanguages(dataSources: data.sources)
                }
                
            }
        }
        
        func fetchCategories(){
            self.categories.accept(Array(Set(dataCategoriesStatic.map { $0.nameOfCategory })))
        }
        
        func fetchCountry(dataSources: [Source]){
            let countries = Array(Set(dataSources.map { $0.country }))
            self.countries.accept(countries)
        }
        
        func fetchLanguages(dataSources: [Source]){
            let languages = Array(Set(dataSources.map { $0.isoLanguageCode }))
            self.languages.accept(languages)
        }
    }
    
}
