//
//  ArticleNewsViewController.swift
//  article-news
//
//  Created by Roby Setiawan on 26/12/22.
//

import UIKit
import RxSwift
import RxCocoa

class ArticleNewsViewController: UIViewController {
    
    var sourceFromHomePage: Source? = nil
    private var categoriesState: [String] = []
    private var sourcesState: [String?] = []
    private var countriesState: [String?] = []
    
    @IBOutlet var currentSelectedFilterChoosed: UILabel!
    @IBOutlet var articleCollectionView: UICollectionView!

    private var viewModel: ArticleNewsModels!
    
    private var bag = DisposeBag()
    
    private lazy var categoryBarButton =
    UIBarButtonItem(image: UIImage(named: "filter")!, style: .plain,
                    target: self, action: #selector(categoryAction))
    
    private lazy var sourceBarButton =
    UIBarButtonItem(image: UIImage(named: "sources")!, style: .plain,
                    target: self, action: #selector(sourceAction))
    
    private lazy var countryBarButton =
    UIBarButtonItem(image: UIImage(named: "country")!, style: .plain,
                    target: self, action: #selector(countryAction))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindTableData()
        bindCategoriesCountriesLanguagesForPopup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        articleCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupUI(){
        // MARK: Initialize View Model dulu untuk fetch data melalu fungsi di init ui  (category, country, source)
        viewModel = ArticleNewsModels()
        
        // MARK: Setup title and label
        title = "article news page"
        if let sourceChoosed = sourceFromHomePage{
            currentSelectedFilterChoosed.text = "\(sourceChoosed.name)"
        }
        bindCurrentSelectedFilterChoosedLabel()
        
        
        // MARK: Setup button items on navbar
        self.navigationItem.rightBarButtonItems = [
            categoryBarButton,
            sourceBarButton,
            countryBarButton
        ]
        // MARK: Setup View for ArticleCollectionViewCell
        
        articleCollectionView.register(ArticleCollectionViewCell.nib(),
                                       forCellWithReuseIdentifier: ArticleCollectionViewCell.identifier)
        articleCollectionView.collectionViewLayout = DailySourceItemLayout()
    }
    
    func bindCurrentSelectedFilterChoosedLabel(){
        viewModel.currentFilteredLabel
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] choosedLabel in
                self.currentSelectedFilterChoosed.text = choosedLabel
            })
            .disposed(by: bag)
    }
    
    func bindTableData(){
        // bind items to table
        viewModel.itemArticles
            .bind(to: articleCollectionView.rx
                .items(cellIdentifier: ArticleCollectionViewCell.identifier,
                       cellType: ArticleCollectionViewCell.self)) {row, model, cell in
                cell.configureCellArtikel(with: model, ltr: false)
            }.disposed(by: bag)
        
        // bind a model selected handler
        articleCollectionView.rx.modelSelected(ArticleElement.self).bind { source in
            print("source diclick \(String(describing: source.title))")
        }.disposed(by: bag)
        
        // MARK: Trigger scroll view when ended
        articleCollectionView.rx.willDisplayCell
            .observe(on: MainScheduler.instance)
            .map({ ($0.at, $0.at.section) })
            .filter({
                let currentSection = $1
                let currentItem    = $0.row
                let allCellSection = self.articleCollectionView.numberOfSections
                let numberOfItem   = self.articleCollectionView.numberOfItems(inSection: currentSection)
                let result = currentSection == allCellSection - 1
                &&
currentItem >= numberOfItem - 1
                return result
            })
            .map({ _ in () })
            .bind(to: viewModel.scrollEnded)
            .disposed(by: bag)
        
        // fetch sources
        
        let resultSource = sourceFromHomePage?.name.replacingOccurrences(of: " ", with: "-")
        viewModel.fetchArticles(articleParameters: ArticleParameters(sources: resultSource?.lowercased()))
    }
    
    func bindCategoriesCountriesLanguagesForPopup(){
        viewModel.categories
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] resultCategories in
                self.categoriesState = resultCategories
            })
            .disposed(by: bag)
        viewModel.countries
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] resultCountries in
                self.countriesState = resultCountries
            })
            .disposed(by: bag)
        viewModel.sources
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] resultSources in
                self.sourcesState = resultSources
            })
            .disposed(by: bag)
    }
    
    
    /*
     // MARK: Action Icon di atas
     
     // untuk tindakan kategori untuk menampilkan sumber filter
     }
     */
    
    @objc func categoryAction(sender: UIButton!) {
        let categoryActivityVC = UIAlertController(title: "Select a Category",
                                                   message: nil,
                                                   preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        categoryActivityVC.addAction(cancelButton)
        
        _ = categoriesState.map {
            let categoryButton = UIAlertAction(title: $0, style: .default, handler: { [weak self] action in
                
                if let category = action.title {
                    self?.viewModel.updateStatePage(newParameters: ArticleParameters(category:category))
                }
            })
            categoryActivityVC.addAction(categoryButton)
        }
        
        let popOver = categoryActivityVC.popoverPresentationController
        popOver?.barButtonItem = categoryBarButton
        popOver?.sourceRect = view.bounds
        self.present(categoryActivityVC, animated: true, completion: nil)
    }
    
    @objc func sourceAction(sender: UIButton!) {
        let sourceActivityVC = UIAlertController(title: "Select a source",
                                                   message: nil,
                                                   preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        sourceActivityVC.addAction(cancelButton)
        
        for source in sourcesState {
            let languageButton = UIAlertAction(title: source, style: .default, handler: { [weak self] _ in
                let resultSource = source?.replacingOccurrences(of: " ", with: "-")
                let newSourceParams = ArticleParameters(sources: resultSource?.lowercased())
                self?.viewModel.updateStatePage(newParameters: newSourceParams)
            })
            sourceActivityVC.addAction(languageButton)
        }
        
        let popOver = sourceActivityVC.popoverPresentationController
        popOver?.barButtonItem = sourceBarButton
        popOver?.sourceRect = view.bounds
        self.present(sourceActivityVC, animated: true, completion: nil)
    }
    
    @objc func countryAction(sender: UIButton!) {
        let countriesActivityVC = UIAlertController(title: "Select a country",
                                                    message: nil,
                                                    preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        countriesActivityVC.addAction(cancelButton)
        
        for country in countriesState {
            let countryButton = UIAlertAction(title: country?.formattedCountryDescription, style: .default, handler: { [weak self] _ in
                self?.countryBarButton.image = nil
                self?.countryBarButton.title = country?.countryFlagFromCountryCode
                let newsSourceParams = ArticleParameters(country: country)
                self?.viewModel.updateStatePage(newParameters: newsSourceParams)
            })
            countriesActivityVC.addAction(countryButton)
        }
        
        let popOver = countriesActivityVC.popoverPresentationController
        popOver?.barButtonItem = categoryBarButton
        popOver?.sourceRect = view.bounds
        self.present(countriesActivityVC, animated: true, completion: nil)
    }
}
