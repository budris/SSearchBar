//
//  ViewController.swift
//  SSearchBarExample
//
//  Created by Andrei Sak on 5.01.21.
//

import UIKit
import SSearchBar

class ViewController: UIViewController {

  @IBOutlet weak var searchBar: SSearchBar!
  @IBOutlet weak var outputTextLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setup the delegate
    searchBar.searchBarDelegate = self
    
    // Or use the block instead of the delegate
    searchBar.searchBarBlock = { [weak self] (searchBar, text) in
      DispatchQueue.main.async {
        self?.outputTextLabel.text = text
      }
    }
    
    // Customize delay value
    searchBar.searchDelay = 0.3
  }
}

// MARK: - SSearchBarDelegate
extension ViewController: SSearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, searchDidStartWith text: String?) {
    outputTextLabel.text = text
  }
}
