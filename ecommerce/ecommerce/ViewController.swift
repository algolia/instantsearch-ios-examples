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
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarNavigationItem: UINavigationItem!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var nbHitsLabel: UILabel!
    
    var searchController: UISearchController!
    var searchProgressController: SearchProgressController!
    
    var isFilterClicked = false
    
    let BAR_COLOR = UIColor(red: 27/256, green: 35/256, blue: 47/256, alpha: 1)
    let TABLE_COLOR = UIColor(red: 248/256, green: 246/256, blue: 252/256, alpha: 1)
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        navigationController?.navigationBar.barTintColor = BAR_COLOR
        navigationController?.navigationBar.isTranslucent = false
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        topBarView.backgroundColor = TABLE_COLOR
        tableView.backgroundColor = TABLE_COLOR
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(filterClicked))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        arrowImageView.isUserInteractionEnabled = true
        arrowImageView.addGestureRecognizer(singleTap)
        
        configureSearchController()
        
        let client = Client(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY)
        let index = client.index(withName: ALGOLIA_INDEX_NAME)
        searcher = Searcher(index: index, resultHandler: self.handleResults)
        searcher.params.hitsPerPage = 15
        
        searchProgressController = SearchProgressController(searcher: searcher)
        searchProgressController.delegate = self
        searcher.params.query = searchController.searchBar.text
        searcher.params.attributesToRetrieve = ["name", "manufacturer", "category", "salePrice", "bestSellingRank", "customerReviewCount", "image"]
        searcher.params.attributesToHighlight = ["name", "category"]
        searcher.search()
    }

    @IBAction func filterClicked(_ sender: Any) {
        arrowImageView.image = isFilterClicked ? UIImage(named: "arrow_down_flat") : UIImage(named: "arrow_up_flat")
        isFilterClicked = !isFilterClicked
    }
    
    func handleResults(results: SearchResults?, error: Error?) {
        guard let results = results else { return }
        if results.page == 0 {
            hits = results.hits
        } else {
            hits.append(contentsOf: results.hits)
        }
        
        nbHitsLabel.text = "\(results.nbHits) results"

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! ItemCell
        
        // Load more?
        if indexPath.row + 5 >= hits.count {
            searcher.loadMore()
        }
        
        cell.item = ItemRecord(json: hits[indexPath.row])
        cell.backgroundColor = TABLE_COLOR
        
        return cell
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search items"
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.barTintColor = BAR_COLOR
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.layer.cornerRadius = 1.0
        searchController.searchBar.clipsToBounds = true
        searchBarView.addSubview(searchController.searchBar)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "FacetSegue") {
            
            let facetTableViewController = segue.destination as! FacetTableViewController
            facetTableViewController.facets = ["facet1", "facet2"]
        }
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

