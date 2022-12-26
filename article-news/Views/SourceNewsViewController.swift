//
//  SourceNewsViewController.swift
//  article-news
//
//  Created by Roby Setiawan on 24/12/22.
//

import UIKit
import RxSwift
import RxCocoa

class SourceNewsViewController: UIViewController {
    var categoryFromHomePage: Category? = nil
    private var categoriesState: [String] = []
    private var languagesState: [String?] = []
    private var countriesState: [String?] = []
    
    @IBOutlet var currentCategory: UILabel!
    
    @IBOutlet var sourceTableView: UITableView!
    
    private var viewModel = SourceArticleNewsModels()
    
    private var bag = DisposeBag()
    
    private lazy var categoryBarButton =
        UIBarButtonItem(image: UIImage(named: "filter")!, style: .plain,
                        target: self, action: #selector(categoryAction))
    
    private lazy var languageBarButton =
        UIBarButtonItem(image: UIImage(named: "language")!, style: .plain,
                        target: self, action: #selector(languageAction))
    
    private lazy var countryBarButton =
        UIBarButtonItem(image: UIImage(named: "country")!, style: .plain,
                        target: self, action: #selector(countryAction))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindTableData()
        bindCategoriesCountriesLanguagesForPopup()
    }
    
    func setupUI(){
        title = "source news page"
        if let categoryChoosed = categoryFromHomePage{
            currentCategory.text = "\(categoryChoosed.nameOfCategory)"
        }
        self.navigationItem.rightBarButtonItems = [
            categoryBarButton,
            languageBarButton,
            countryBarButton
        ]
    }
    
    func bindTableData(){
        // bind items to table
        viewModel.itemSources.bind(to: sourceTableView.rx.items(cellIdentifier: "SourceCell", cellType: UITableViewCell.self)){row,model,cell in
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = "source of \(row + 1)"
        }.disposed(by: bag)
        
        // bind a model selected handler
        sourceTableView.rx.modelSelected(Source.self).bind { source in
            let resultData: Source = source
            self.performSegue(withIdentifier: "moveToArticleNews", sender: resultData)
        }.disposed(by: bag)
        
        // fetch sources
        viewModel.fetchSources(sourceParameters: SourceParameters(category: categoryFromHomePage?.nameOfCategory.lowercased()), fetchFirst: true)
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
        viewModel.languages
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] resultLanguages in
                self.languagesState = resultLanguages
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
                    self?.currentCategory.text = category
                    self?.viewModel.fetchSources(sourceParameters: SourceParameters(category: category.lowercased()), fetchFirst: false)
                }
            })
            categoryActivityVC.addAction(categoryButton)
        }
        
        
        
        let popOver = categoryActivityVC.popoverPresentationController
        popOver?.barButtonItem = categoryBarButton
        popOver?.sourceRect = view.bounds
        self.present(categoryActivityVC, animated: true, completion: nil)
    }
    
    @objc func languageAction(sender: UIButton!) {
        let languageActivityVC = UIAlertController(title: "Select a language",
                                                   message: nil,
                                                   preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)

        languageActivityVC.addAction(cancelButton)

        for lang in languagesState {
            let languageButton = UIAlertAction(title: lang?.languageStringFromISOCode, style: .default, handler: { [weak self] _ in
                let newsSourceParams = SourceParameters(language: lang)
                self?.viewModel.fetchSources(sourceParameters: newsSourceParams, fetchFirst: false)
            })
            languageActivityVC.addAction(languageButton)
        }
        
        
        
        let popOver = languageActivityVC.popoverPresentationController
        popOver?.barButtonItem = languageBarButton
        popOver?.sourceRect = view.bounds
        self.present(languageActivityVC, animated: true, completion: nil)
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
                let newsSourceParams = SourceParameters(country: country)
                self?.viewModel.fetchSources(sourceParameters: newsSourceParams, fetchFirst: false)
            })
            countriesActivityVC.addAction(countryButton)
        }
        
        
        
        let popOver = countriesActivityVC.popoverPresentationController
        popOver?.barButtonItem = countryBarButton
        popOver?.sourceRect = view.bounds
        self.present(countriesActivityVC, animated: true, completion: nil)
    }
    
    /*
     // MARK: Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ) {
      if segue.identifier == "moveToArticleNews" {
        if let detaiViewController = segue.destination as? ArticleNewsViewController {
            detaiViewController.sourceFromHomePage = sender as? Source
        }
      }
    }
    
}
