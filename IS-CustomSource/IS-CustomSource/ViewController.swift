//
//  ViewController.swift
//  IS-CustomSource
//
//  Created by Robert Mogos on 06/10/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore

class ViewController: UIViewController, HitsTableViewDataSource {
    
    var hitsController: HitsController!
    var instantSearch: InstantSearch!
    var searchBar: SearchBarWidget!
    
    lazy var tableView: HitsTableWidget = {
        HitsTableWidget(frame: .zero, style: .plain)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar = SearchBarWidget(frame: .zero)
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(onFiltersTapped))
        self.edgesForExtendedLayout = []
        tableView.frame = self.view.frame
        self.view.addSubview(tableView)
        hitsController = HitsController(table: tableView)
        tableView.dataSource = hitsController
        tableView.delegate = hitsController
        hitsController.tableDataSource = self
        configureInstantSearch()
        
        tableView.estimatedRowHeight = 80
        tableView.infiniteScrolling = false
    }
    
    @objc func onFiltersTapped() {
        let refinementViewController = RefinementViewController()
        refinementViewController.instantSearch = instantSearch
        self.navigationController?.pushViewController(refinementViewController, animated: true)
    }
    
    func configureInstantSearch() {
        
        // Initialising an Index
        
        let index = CustomSearchableImplementation()
        //let index = SomeImplementation()
        //let index = CustomBackendMovies()
        
        let searcher = Searcher(index: index)
        instantSearch = InstantSearch.init(searcher: searcher)
        instantSearch.registerAllWidgets(in: self.view)
        instantSearch.register(widget: searchBar)
        instantSearch.searcher.params.addFacetRefinement(name: "category", value: "someCat")
        instantSearch.searcher.params.addNumericRefinement("price", .greaterThanOrEqual, 20)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String: Any]) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")
        }
        
        //let name = hit["title"] as! String
        let name = hit["nameCustom"] as! String
        
        cell!.textLabel?.text = name
        //cell!.detailTextLabel?.text = location
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

