//
//  SSearchBar.swift
//  SSearchBar
//
//  Created by Andrey Sak on 6/26/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

protocol SSearchBarDelegate: UISearchBarDelegate {
    func searchDidStart(_ searchBar: UISearchBar, didStartWith text: String?)
}

class SSearchBar: UISearchBar {
    private static let defaultDelay: TimeInterval = 0.5
    
    weak public var sSearchBarDelegate: SSearchBarDelegate?
    
    public var delayForStartingSearch: TimeInterval = SSearchBar.defaultDelay
    
    fileprivate var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
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
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: delayForStartingSearch,
                                     target: self,
                                     selector: #selector(SSearchBar.fire(_:)),
                                     userInfo: searchBar,
                                     repeats: false)
    }
    
}
