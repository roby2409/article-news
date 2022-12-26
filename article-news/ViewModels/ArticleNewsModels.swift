//
//  ArticleNewsModels.swift
//  article-news
//
//  Created by Roby Setiawan on 26/12/22.
//  this class fetch source for navbar, data article for page, and update state source

import Foundation
import UIKit
import RxSwift
import RxRelay

class ArticleNewsModels{
    // MARK: repository
    private let searchArticleRepository = SearchArticleRepository.shared
    private let searchSourceRepository = SearchSourceRepository.shared
    
    // MARK: State article page (process)
    private var currentPage  = BehaviorRelay(value: 1)
    private var currentArticleParameters = BehaviorRelay(value: ArticleParameters())
    private let disposeBag   = DisposeBag()
    
    
    // MARK: State article page (ui)
    // 1. For setup ui navbar
    var itemSources          = BehaviorRelay<[Source]>(value: [])
    var categories           = PublishRelay<[String]>()
    var countries            = PublishRelay<[String?]>()
    var sources              = PublishRelay<[String?]>()
    var scrollEnded          = PublishRelay<Void>()
    
    // 2. For setup ui table data articles
    var itemArticles          = BehaviorRelay<[ArticleElement]>(value: [])
    // 3. For setup ui label current choosed filter
    var currentFilteredLabel  = BehaviorRelay(value: "")
    var hasAnError       = PublishRelay<String>()
    
    //    func setupUiArticlePage(currentLabel: String) {
    init(){
        
        fetchSourcesForSetupNavbar()
        bindScrollEnded()
    }
    
    func fetchSourcesForSetupNavbar(){
        self.searchSourceRepository.searchSources(sourceRequestParams: SourceParameters()){ [weak self] response in
            switch response {
            case .failure(let e):
                self?.hasAnError.accept(e.localizedDescription)
                self?.itemSources.accept([])
                
            case .success(let data):
                let sources = data.sources
                self?.itemSources.accept(sources)
                self?.categories.accept(Array(Set(dataCategoriesStatic.map { $0.nameOfCategory })))
                self?.countries.accept(Array(Set(sources.map { $0.country })))
                self?.sources.accept(Array(Set(sources.map { $0.name })))
                
                
            }
        }
    }
    
    // MARK: update pagination and keep filtered value parameter on navbar
    func updateStatePage(newParameters: ArticleParameters){
        self.currentPage.accept(1)
        var currentParameters = self.currentArticleParameters.value
        
        // MARK: Update with new parameters or  keep old parameter
        currentParameters.category = newParameters.category ?? currentParameters.category
        currentParameters.country = newParameters.country ?? currentParameters.country
        
        /// if new source and (there new update parameters country or category)
        /// update (category and country) above will be delete  (because in documentation cannot mix)
        if let newSource = newParameters.sources{
            currentParameters.sources = newSource
            if(currentParameters.category != nil || currentParameters.country != nil){
                currentParameters.category = nil
                currentParameters.country = nil
            }
        }else{
            currentParameters.sources = nil
        }
        self.fetchArticles(articleParameters: currentParameters)
    }
    /// Loading images from given api
    func fetchArticles(articleParameters: ArticleParameters) {
        // always keep filtered value parameter after fetch or after update (processing)
        self.currentArticleParameters.accept(articleParameters)
        
        // update label (ui)
        print("article parameters : \(articleParameters)")
        self.currentFilteredLabel.accept(articleParameters.toLabel())
        
        
        let currentPage = self.currentPage.value
        print("current page now :  \(currentPage)")
        self.searchArticleRepository.processingEndpointTopHeadLines(articleRequestParams: articleParameters, page: currentPage){ [weak self] response in
            switch response {
            case .failure(let e):
                self?.hasAnError.accept(e.localizedDescription)
                self?.itemArticles.accept([])
                
            case .success(let data):
                let articles = data.articles
                let existData = self?.itemArticles.value ?? []
                
                /// add new data to nil array
                if existData.isEmpty {
                    self?.itemArticles.accept(articles)
                } else {
                    /// update exist data with adding new data
                    self?.itemArticles.accept(existData + articles)
                }
            }
        }
    }
    
    /// trigger when scroll ended --|-- load more images
    func bindScrollEnded() {
        scrollEnded
            .subscribe { [weak self] _ in
                if let newPage = self?.currentPage.value {
                    let currentPage = newPage
                    self?.currentPage.accept(currentPage - 1)
                    
                    let currentParameters = self?.currentArticleParameters.value
                    self?.fetchArticles(articleParameters: currentParameters ?? ArticleParameters())
                }
            }
            .disposed(by: disposeBag)
    }
    
}

