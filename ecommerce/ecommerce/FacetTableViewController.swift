//
//  FacetTableViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 07/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import InstantSearchCore
import UIKit

class FacetTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var nbHitsLabel: UILabel!
    @IBOutlet weak var tableView: RefinementListView!
    
    
    var searchController: UISearchController!
    let FACET_NAME = "category"
//    var instantSearch: InstantSearch!
    var instantSearchPresenter: InstantSearchPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantSearchPresenter.addAllWidgets(in: self.view)
//        categoryFacets = instantSearch.getSearchFacetRecords(withFacetName: FACET_NAME)!
//        
//        instantSearch.addWidget(stats: nbHitsLabel)
        configureNavBar()
        topBarView.backgroundColor = ColorConstants.tableColor
        configureSearchController()
        configureTable()
//        instantSearch.set(facetSearchController: searchController)
//        instantSearch.facetDataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.isActive = false
    }
    
    // MARK: - Table view data source
    
    func handle(results: SearchResults, error: Error?) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tableView.numberOfRows(in: section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath) as! FacetCategoryCell
        cell.facet = self.tableView.facetForRow(at: indexPath)
        cell.isRefined = self.tableView.isRefined(at: indexPath)
        cell.backgroundColor = ColorConstants.tableColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.didSelectRow(at: indexPath)
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
    
    deinit {
        self.searchController?.view.removeFromSuperview()
    }
}
