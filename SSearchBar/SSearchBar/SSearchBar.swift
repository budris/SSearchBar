//
//  SSearchBar.swift
//  SSearchBar
//
//  Created by Andrey Sak on 6/26/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

public protocol SSearchBarProtocol {
    var searchBarDelegate: SSearchBarDelegate? { get set }
    var searchBarBlock: SSearchBarBlock? { get set }
    
    var searchDelay: TimeInterval { get set }
    
    func stopTracking()
}

public typealias SSearchBarBlock = ((_ searchBar: UISearchBar, _ searchText: String?) -> ())

public protocol SSearchBarDelegate: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, searchDidStartWith searchText: String?)
}

public final class SSearchBar: UISearchBar, SSearchBarProtocol {
    
    private static let defaultDelay: TimeInterval = 0.5
    
    weak public var searchBarDelegate: SSearchBarDelegate?
    public var searchBarBlock: SSearchBarBlock?
    
    public var searchDelay: TimeInterval = SSearchBar.defaultDelay
    
    fileprivate var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
    }
    
    override public func responds(to aSelector: Selector!) -> Bool {
        if let sSearchBarDelegate = searchBarDelegate,
            sSearchBarDelegate.responds(to: aSelector) {
            return true
        }
        
        return super.responds(to: aSelector)
    }
    
    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let sSearchBarDelegate = searchBarDelegate,
            sSearchBarDelegate.responds(to: aSelector) {
            return sSearchBarDelegate
        }
        
        return super.forwardingTarget(for: aSelector)
    }
    
    public func stopTracking() {
        timer?.invalidate()
    }
    
    @IBAction func fire(_ timer: Timer) {
        guard let searchBar = timer.userInfo as? UISearchBar else {
            return
        }
        
        let searchText = searchBar.text
        searchBarDelegate?.searchBar(searchBar, searchDidStartWith: searchText)
        searchBarBlock?(self, searchText)
    }
}

extension SSearchBar: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarDelegate?.searchBar?(searchBar, textDidChange: searchText)
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: searchDelay,
                                     target: self,
                                     selector: #selector(SSearchBar.fire(_:)),
                                     userInfo: searchBar,
                                     repeats: false)
    }
}
