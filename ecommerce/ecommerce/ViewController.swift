//
//  ViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 02/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearchCore
import AlgoliaSearch

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, SearchProgressDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var searchProgressController: SearchProgressController!
    
    let ALGOLIA_APP_ID = "latency"
    let ALGOLIA_INDEX_NAME = "bestbuy_promo"
    let ALGOLIA_API_KEY = Bundle.main.infoDictionary!["AlgoliaApiKey"] as! String
    var searcher: Searcher!
    var hits: [JSONObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        configureSearchController()
        
        let client = Client(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY)
        let index = client.index(withName: ALGOLIA_INDEX_NAME)
        searcher = Searcher(index: index, resultHandler: self.handleResults)
        searcher.params.hitsPerPage = 15
        
        searchProgressController = SearchProgressController(searcher: searcher)
        searchProgressController.delegate = self
        searcher.params.query = searchController.searchBar.text
        searcher.params.attributesToRetrieve = ["name", "manufacturer", "category", "salePrice", "bestSellingRank", "customerReviewCount"]
        searcher.params.attributesToHighlight = ["name"]
        searcher.search()
    }

    
    func handleResults(results: SearchResults?, error: Error?) {
        guard let results = results else { return }
        if results.page == 0 {
            hits = results.hits
        } else {
            hits.append(contentsOf: results.hits)
        }

        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableView Delegate and Datasource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(hits)
        return hits.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        
        // Load more?
        if indexPath.row + 5 >= hits.count {
            searcher.loadMore()
        }
        
        let item = ItemRecord(json: hits[indexPath.row])
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.category
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        searcher.params.query = searchString
        searcher.search()
    }
    
    // MARK: - SearchProgressDelegate
    
    func searchDidStart(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func searchDidStop(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

