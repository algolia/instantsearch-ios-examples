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

class ItemTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, AlgoliaHitDataSource {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarNavigationItem: UINavigationItem!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var nbHitsLabel: UILabel!
    
    var searchController: UISearchController!
    
    var isFilterClicked = false
    
    let BAR_COLOR = UIColor(red: 27/256, green: 35/256, blue: 47/256, alpha: 1)
    let TABLE_COLOR = UIColor(red: 248/256, green: 246/256, blue: 252/256, alpha: 1)
    
    var searchCoordinator: SearchCoordinator!
    var itemsToShow: [JSONObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureToolBar()
        configureSearchController()
        configureTable()
        configureSearchCoordinator()
    }
    
    func configureSearchCoordinator() {
        searchCoordinator = SearchCoordinator(searchController: searchController)
        searchCoordinator.hitDataSource = self
    }
    
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = TABLE_COLOR
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.barTintColor = BAR_COLOR
        navigationController?.navigationBar.isTranslucent = false
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    func configureToolBar() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(filterClicked))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        arrowImageView.isUserInteractionEnabled = true
        arrowImageView.addGestureRecognizer(singleTap)
        topBarView.backgroundColor = TABLE_COLOR
    }
    
    // MARK: AlgoliaHitDataSource Datasource functions
    
    func handle(hits: [JSONObject]) {
        itemsToShow = hits
        tableView.reloadData()
    }
    
    func handle(results: SearchResults, error: Error?) {
        nbHitsLabel.text = "\(results.nbHits) results"
    }

    @IBAction func filterClicked(_ sender: Any) {
        arrowImageView.image = isFilterClicked ? UIImage(named: "arrow_down_flat") : UIImage(named: "arrow_up_flat")
        isFilterClicked = !isFilterClicked
    }
    
    // MARK: UITableView Delegate and Datasource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToShow.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! ItemCell
        
        searchCoordinator.loadMoreIfNecessary(rowNumber: indexPath.row)
        
        cell.item = ItemRecord(json: itemsToShow[indexPath.row])
        cell.backgroundColor = TABLE_COLOR
        
        return cell
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
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
            facetTableViewController.searchCoordinator = searchCoordinator
        }
    }
}

