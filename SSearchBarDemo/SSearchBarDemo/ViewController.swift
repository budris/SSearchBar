//
//  ViewController.swift
//  SSearchBarDemo
//
//  Created by Andrey Sak on 6/28/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class SearchItem: Searchable {
    var searchField: String {
        return field
    }
    
    private let field: String
    
    init(field: String) {
        self.field = field
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: SSearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.setupSeachList(with: [SearchItem(field: "Swift"),
                                        SearchItem(field: "C#"),
                                        SearchItem(field: "Objective-C"),
                                        SearchItem(field: "Java")])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}

