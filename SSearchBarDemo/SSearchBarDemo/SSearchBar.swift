//
//  SSearchBar.swift
//  SSearchBar
//
//  Created by Andrey Sak on 6/26/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

public protocol SSearchBarDelegate: UISearchBarDelegate {
    func searchDidStart(_ searchBar: UISearchBar, didStartWith text: String?)
}

public protocol Searchable {
    var searchField: String { get }
}

class SSearchBar: UISearchBar {
    private static let defaultDelay: TimeInterval = 0.5
    
    weak public var sSearchBarDelegate: SSearchBarDelegate?
    
    public var delayForStartingSearch: TimeInterval = SSearchBar.defaultDelay
    
    fileprivate var timer: Timer?
    fileprivate var searchResultsView: UITableView!
    fileprivate var searchList: [Searchable]
    
    override init(frame: CGRect) {
        searchList = []
        
        super.init(frame: frame)
        
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        searchList = []
        
        super.init(coder: aDecoder)
        
        sharedInit()
    }
    
    public func setupSeachList(with elements: [Searchable]) {
        searchList = elements
        
        
    }
    
    private func sharedInit() {
        delegate = self

        
        
    }
    
    func configViews() {
        searchResultsView = UITableView(frame: CGRect(x: 0,
                                                      y: 10,
                                                      width: 300,
                                                      height: 200))
        searchResultsView.dataSource = self
        
        superview?.addSubview(searchResultsView)
        
        NSLayoutConstraint(item: searchResultsView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: 50).isActive = true
        NSLayoutConstraint(item: searchResultsView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: searchResultsView,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 100).isActive = true
        
        searchResultsView.reloadData()
    }
    
    private func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }

    private func getEditText() -> UITextField {
        return value(forKey: "searchField") as! UITextField
    }
    
    
    override func responds(to aSelector: Selector!) -> Bool {
        if let sSearchBarDelegate = sSearchBarDelegate,
            sSearchBarDelegate.responds(to: aSelector) {
            return true
        }
        
        return super.responds(to: aSelector)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let sSearchBarDelegate = sSearchBarDelegate,
            sSearchBarDelegate.responds(to: aSelector) {
            return sSearchBarDelegate
        }
        
        return super.forwardingTarget(for: aSelector)
    }
    
    func fire(_ timer: Timer) {
        guard let searchBar = timer.userInfo as? UISearchBar else {
            return
        }
        
        let searchText = searchBar.text
        sSearchBarDelegate?.searchDidStart(searchBar, didStartWith: searchText)
    }
    
    public func stopTracking() {
        timer?.invalidate()
    }
    
}

extension SSearchBar: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sSearchBarDelegate?.searchBar?(searchBar, textDidChange: searchText)
        
        if searchResultsView == nil { configViews() }
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: delayForStartingSearch,
                                     target: self,
                                     selector: #selector(SSearchBar.fire(_:)),
                                     userInfo: searchBar,
                                     repeats: false)
    }
    
}

extension SSearchBar: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = searchList[indexPath.row].searchField
        
        return cell
    }
    
}
