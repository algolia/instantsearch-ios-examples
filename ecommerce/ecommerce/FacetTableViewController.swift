//
//  FacetTableViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 07/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import InstantSearchCore
import UIKit

class FacetTableViewController: UITableViewController {
    
    var facets: [FacetValue] = []
    var searcher: Searcher!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    func handleResults(results: SearchResults?, error: Error?) {
        guard let results = results else { return }

        facets = getFacets(with: results, andFacetName: "category")
        
        tableView.reloadData()
    }
    
    func getFacets(with results: SearchResults!, andFacetName facetName:String) -> [FacetValue] {
        // Sort facets: first selected facets, then by decreasing count, then by name.
        return FacetValue.listFrom(facetCounts: results.facets(name: facetName), refinements: searcher.params.buildFacetRefinements()[facetName]).sorted() { (lhs, rhs) in
            // When using cunjunctive faceting ("AND"), all refined facet values are displayed first.
            // But when using disjunctive faceting ("OR"), refined facet values are left where they are.
            let disjunctiveFaceting = results.disjunctiveFacets.contains(facetName)
            let lhsChecked = searcher.params.hasFacetRefinement(name: facetName, value: lhs.value)
            let rhsChecked = searcher.params.hasFacetRefinement(name: facetName, value: rhs.value)
            if !disjunctiveFaceting && lhsChecked != rhsChecked {
                return lhsChecked
            } else if lhs.count != rhs.count {
                return lhs.count > rhs.count
            } else {
                return lhs.value < rhs.value
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return facets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath)
        let facet = facets[indexPath.row]
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
        searcher.params.toggleFacetRefinement(name: "category", value: facets[indexPath.item].value)
        searcher.search()
        tableView.reloadData()
    }
}
