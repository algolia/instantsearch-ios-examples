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
    
    var searchController: UISearchController!
    let FACET_NAME = "category"
    var instantSearch: InstantSearch!
    var categoryFacets: [FacetRecord] = []
    var nbHits = 0 {
        didSet {
            nbHitsLabel.text = "\(nbHits) results"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: This should be done in a better way.
        categoryFacets = instantSearch.getSearchFacetRecords(withFacetName: FACET_NAME)!
        
        nbHits = instantSearch.nbHits
        configureNavBar()
        topBarView.backgroundColor = ColorConstants.tableColor
        configureSearchController()
        configureTable()
        instantSearch.set(facetSearchController: searchController)
        instantSearch.facetDataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.isActive = false
    }

    // MARK: - Table view data source

    func handle(results: SearchResults, error: Error?) {
        nbHits = results.nbHits
    }
    
    func handle(facetRecords: [FacetRecord]?) {
        categoryFacets = facetRecords!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath) as! FacetCategoryCell
        let facet = categoryFacets[indexPath.row]
        facet.isRefined = instantSearch.searcher.params.hasFacetRefinement(name: FACET_NAME, value: categoryFacets[indexPath.item].value!)
        cell.facet = facet
        cell.backgroundColor = ColorConstants.tableColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        instantSearch.toggleFacetRefinement(name: FACET_NAME, value: categoryFacets[indexPath.item].value!)
    }
    
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = ColorConstants.tableColor
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.barTintColor = ColorConstants.barBackgroundColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : ColorConstants.barTextColor]
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search categories"
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.barTintColor = ColorConstants.barBackgroundColor
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.layer.cornerRadius = 1.0
        searchController.searchBar.clipsToBounds = true
        searchBarView.addSubview(searchController.searchBar)
    }
}
