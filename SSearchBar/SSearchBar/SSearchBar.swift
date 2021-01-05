//
//  SSearchBar.swift
//  SSearchBar
//
//  Created by Andrey Sak on 6/26/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

// MARK: - SSearchBarProtocol
public protocol SSearchBarProtocol {
  var searchBarDelegate: SSearchBarDelegate? { get set }
  
  var searchBarBlock: SSearchBarBlock? { get set }
  
  var searchDelay: TimeInterval { get set }
  
  func stopTracking()
}

// MARK: - SSearchBarBlock
public typealias SSearchBarBlock = ((_ searchBar: SSearchBar, _ text: String?) -> ())

// MARK: - SSearchBarDelegate
public protocol SSearchBarDelegate: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, searchDidStartWith text: String?)
}

public final class SSearchBar: UISearchBar, SSearchBarProtocol {
  
  private static let defaultDelay: TimeInterval = 0.5
  /// The delegate objects which be notified to input text actions
  weak public var searchBarDelegate: SSearchBarDelegate?
  /// The block which is called to input text actions
  public var searchBarBlock: SSearchBarBlock?
  /// The delay time interval after which delegate objects which notified to input text actions
  /// Default value is 0.5 seconds.
  public var searchDelay: TimeInterval = SSearchBar.defaultDelay
  
  private var timer: Timer?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    delegate = self
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    delegate = self
  }
  
  deinit {
    timer?.invalidate()
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
  
  /// Stop tracking text input actions.
  /// The delegate object will not be notified about input actions.
  public func stopTracking() {
    timer?.invalidate()
  }
  
  @IBAction private func fire(_ timer: Timer) {
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
    
    timer = Timer.scheduledTimer(
      timeInterval: searchDelay,
      target: self,
      selector: #selector(SSearchBar.fire(_:)),
      userInfo: searchBar,
      repeats: false
    )
  }
}
