//
//  ViewController.swift
//  article-news
//
//  Created by Roby Setiawan on 23/12/22.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome to"
        // Do any additional setup after loading the view.
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ) {
      if segue.identifier == "moveToSourceNews" {
        if let detaiViewController = segue.destination as? SourceNewsViewController {
          detaiViewController.categoryFromHomePage = sender as? Category
        }
      }
    }
    
//    MenuCollectionViewCellController
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCategoriesStatic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CategoryCollectionViewCell",
            for: indexPath
          ) as! CategoryCollectionViewCell
          
        
        let data = dataCategoriesStatic[indexPath.row]
        cell.nameOfCategory.text = data.nameOfCategory
        let imageData = UIImage(named: data.nameOfCategory.lowercased())
        cell.categoryImageView.image = imageData // setting your bear image here
            
        return cell
    }
    
}


extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = dataCategoriesStatic[indexPath.row]
        performSegue(withIdentifier: "moveToSourceNews", sender: data)
    }
}
