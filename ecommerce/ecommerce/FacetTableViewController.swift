//
//  FacetTableViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 07/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import InstantSearchCore
import UIKit

class FacetTableViewController: UITableViewController, AlgoliaFacetDataSource {
    
    var searchCoordinator: SearchCoordinator!
    var categoryFacets: [FacetValue] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: This should be done in a better way.
        categoryFacets = searchCoordinator.categoryFacets
        searchCoordinator.facetDataSource = self
    }

    // MARK: - Table view data source

    func handle(facets: [String : [FacetValue]]) {
        categoryFacets = facets["category"]!
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryFacets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath)
        let facet = categoryFacets[indexPath.row]
        cell.textLabel?.text = facet.value
        cell.detailTextLabel?.text = "\(facet.count)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        searchCoordinator.toggleFacetRefinement(name: "category", value: categoryFacets[indexPath.item].value)
    }
}
