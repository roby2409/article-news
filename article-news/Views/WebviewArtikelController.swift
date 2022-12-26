//
//  WebviewArtikelController.swift
//  article-news
//
//  Created by Roby Setiawan on 27/12/22.
//

import Foundation
import SafariServices

class WebviewArtikelController: SFSafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.preferredControlTintColor = .label
        } else {
            self.preferredControlTintColor = .black
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
