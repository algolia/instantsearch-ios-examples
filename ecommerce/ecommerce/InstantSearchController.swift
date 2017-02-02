//
//  InstantSearchControllerViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 02/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

protocol InstantSearchControllerDelegate {
    func didStartSearching()
    func didTapOnSearchButton()
    func didTapOnCancelButton()
    func didChangeSearchText(_ searchText: String)
}


class InstantSearchController: UISearchController, UISearchBarDelegate {
    
    var instantSearchBar: InstantSearchBar!
    var instantSearchControllerDelegate: InstantSearchControllerDelegate!
    
    // MARK: Initialization
    
    init(searchResultsController: UIViewController!, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Custom functions
    
    func configureSearchBar(_ frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
        instantSearchBar = InstantSearchBar(frame: frame, font: font , textColor: textColor)
        
        instantSearchBar.barTintColor = bgColor
        instantSearchBar.tintColor = textColor
        instantSearchBar.showsBookmarkButton = false
        instantSearchBar.showsCancelButton = false
        instantSearchBar.delegate = self
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        instantSearchControllerDelegate.didStartSearching()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        instantSearchBar.resignFirstResponder()
        instantSearchControllerDelegate.didTapOnSearchButton()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        instantSearchBar.resignFirstResponder()
        instantSearchControllerDelegate.didTapOnCancelButton()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        instantSearchControllerDelegate.didChangeSearchText(searchText)
    }
    
}
