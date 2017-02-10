//
//  FacetTableViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 07/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import InstantSearchCore
import UIKit

class FacetTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AlgoliaFacetDataSource {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var nbHitsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let TABLE_COLOR = UIColor(red: 248/256, green: 246/256, blue: 252/256, alpha: 1)
    let BAR_COLOR = UIColor(red: 27/256, green: 35/256, blue: 47/256, alpha: 1)
    
    var searchController: UISearchController!
    let FACET_NAME = "category"
    var searchCoordinator: SearchCoordinator!
    var categoryFacets: [FacetRecord] = []
    var nbHits = 0 {
        didSet {
            nbHitsLabel.text = "\(nbHits) results"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: This should be done in a better way.
        categoryFacets = searchCoordinator.getFacetRecords(withFacetName: FACET_NAME)
        
        nbHits = searchCoordinator.nbHits
        configureNavBar()
        topBarView.backgroundColor = TABLE_COLOR
        configureSearchController()
        configureTable()
        searchCoordinator.set(facetSearchController: searchController)
        searchCoordinator.facetDataSource = self
    }

    // MARK: - Table view data source

    func handle(results: SearchResults, error: Error?) {
        nbHits = results.nbHits
    }
    
    func handle(facetRecords: [FacetRecord]) {
        categoryFacets = facetRecords
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryFacets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath)
        let facet = categoryFacets[indexPath.row]
        cell.textLabel?.text = facet.value
        cell.detailTextLabel?.text = "\(facet.count)"
        if searchCoordinator.searcher.params.hasFacetRefinement(name: FACET_NAME, value: categoryFacets[indexPath.item].value) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        cell.backgroundColor = TABLE_COLOR
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchCoordinator.toggleFacetRefinement(name: FACET_NAME, value: categoryFacets[indexPath.item].value)
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
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        
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
}
