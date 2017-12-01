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

class QuerySuggestionDemo: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: MultiHitsTableWidget!
    @IBOutlet weak var searchBar: SearchBarWidget!
    
    var multiHitsViewModel: MultiHitsViewModel!
    var searchViewModel: SearchViewModel!
    
    var isTextBarClicked = false
    
    private let ALGOLIA_APP_ID = "latency"
    private let ALGOLIA_API_KEY = "afc3dd66dd1293e2e2736a5a51b05c0a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searcherIds: [SearcherId] = [SearcherId.init(indexName: "instant_search"), SearcherId.init(indexName: "instantsearch_query_suggestions")]
        InstantSearch.shared.configure(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY, searcherIds: searcherIds)
        
        InstantSearch.shared.register(widget: searchBar)
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
        if section == 0 && !isTextBarClicked {
            return 0
        }
        
        return multiHitsViewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        let hit = multiHitsViewModel.hitForRow(at: indexPath)
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "querySuggestionCell", for: indexPath)
            cell.textLabel?.text = hit["query"] as? String
            cell.textLabel?.textColor = UIColor.gray
            cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "query")?.value
            cell.textLabel?.highlightedTextColor = UIColor.black
            cell.textLabel?.isHighlightingInversed = true
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
            cell.textLabel?.text = hit["name"] as? String
            cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
            cell.textLabel?.highlightedTextColor = UIColor.black
            cell.textLabel?.highlightedBackgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 100 / 255, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hit = multiHitsViewModel.hitForRow(at: indexPath)
        
        if indexPath.section == 0 {
            let query = hit["query"] as! String
            InstantSearch.shared.search(with: query)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
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
        if section == 0 {
            return 0
        } else {
            return 40
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.search(query: searchText)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isTextBarClicked = true
        searchViewModel.search(query: searchBar.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

