//
//  FacetTableViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 07/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import InstantSearch
import UIKit

class TypeFacetTableViewController: UIViewController, RefinementTableViewDataSource {
    
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var nbHitsLabel: UILabel!
    @IBOutlet weak var tableView: RefinementTableWidget!
    
    var refinementController: RefinementController!
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refinementController = RefinementController(table: tableView)
        tableView.dataSource = refinementController
        tableView.delegate = refinementController
        refinementController.tableDataSource = self
        
        InstantSearch.shared.registerAllWidgets(in: self.view)
        configureNavBar()
        topBarView.backgroundColor = ColorConstants.tableColor
        configureSearchController()
        configureTable()
        LayoutHelpers.setupResultButton(button: resultButton)
        resultButton.addTarget(self, action: #selector(resultButtonClicked), for: .touchUpInside)
    }

    override func viewWillDisappear(_ animated: Bool) {
        searchController.isActive = false
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath) as! FacetCategoryCell
        cell.facet = facet
        cell.count = count
        cell.isRefined = refined
        cell.backgroundColor = ColorConstants.tableColor
        
        return cell
    }
    
    func configureTable() {
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
        
        searchController.searchBar.placeholder = "Search types"
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.barTintColor = ColorConstants.barBackgroundColor
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.layer.cornerRadius = 1.0
        searchController.searchBar.clipsToBounds = true
        searchBarView.addSubview(searchController.searchBar)
    }
    
    func resultButtonClicked() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? ItemTableViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    deinit {
        self.searchController?.view.removeFromSuperview()
    }
}
