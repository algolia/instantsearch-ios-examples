//
//  QuerySuggestionDemo.swift
//  InstantSearchDemo
//
//  Created by Guy Daher on 11/29/17.
//  Copyright © 2017 Algolia. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore
import AFNetworking

class QuerySuggestionDemo: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: MultiHitsTableWidget!
    @IBOutlet weak var searchBar: SearchBarWidget!
    
    var multiHitsViewModel: MultiHitsViewModel!
    var searchViewModel: SearchViewModel!
    
    var isTextBarClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multiHitsViewModel = MultiHitsViewModel(view: tableView)
        InstantSearch.shared.register(viewModel: multiHitsViewModel)
        searchViewModel = SearchViewModel(view: searchBar)
        InstantSearch.shared.register(viewModel: searchViewModel)
        InstantSearch.shared.search()
        
        searchBar.placeholder = "Search a pro..."
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return multiHitsViewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && !isTextBarClicked { // Show query suggestion on when textbar is clicked
            return 0
        }
        
        return multiHitsViewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        let hit = multiHitsViewModel.hitForRow(at: indexPath)
        
        if indexPath.section == 0 { // Query suggestion
            cell = tableView.dequeueReusableCell(withIdentifier: "querySuggestionCell", for: indexPath)
            cell.textLabel?.text = hit["query"] as? String
            cell.textLabel?.textColor = UIColor.gray
            cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "query")?.value
            cell.textLabel?.highlightedTextColor = UIColor.black
            cell.textLabel?.isHighlightingInversed = true
        } else { // Instant Results
            cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
            cell.textLabel?.text = hit["name"] as? String
            cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
            cell.textLabel?.highlightedTextColor = UIColor.black
            cell.textLabel?.highlightedBackgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 100 / 255, alpha: 1)
            if let image = hit["image"] as? String, let imageUrl = URL(string: image) {
                cell.imageView?.contentMode = .scaleAspectFit
                cell.imageView?.setImageWith(imageUrl, placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.imageView?.image = UIImage(named: "placeholder")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hit = multiHitsViewModel.hitForRow(at: indexPath)
        
        if indexPath.section == 0 { // Query suggestion
            let query = hit["query"] as! String
            InstantSearch.shared.search(with: query)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 { // Query suggestion
            return nil
        }
        
        let label = UILabel(frame: CGRect(x: 12, y: 0, width: 300, height: 40))
        if tableView == self.tableView {
            if section == 1 {
                label.text = "Best results"
            }
        }
        
        let view = UIView()
        view.addSubview(label)
        view.backgroundColor = UIColor.lightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { // Query suggestion
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.search(query: searchText)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isTextBarClicked = true
        searchViewModel.search(query: searchBar.text)
    }
}
