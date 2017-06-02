//
//  ViewController.swift
//  Getting Started Programatically
//
//  Created by Guy Daher on 01/06/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearch

class ViewController: HitsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = SearchBarWidget(frame: .zero)
        let stats = StatsLabelWidget(frame: .zero)
        let tableView = HitsTableWidget(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        stats.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(searchBar)
        self.view.addSubview(stats)
        self.view.addSubview(tableView)
        
        let views = ["searchBar": searchBar, "stats": stats, "tableView": tableView]
        
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[searchBar]-10-[stats]-10-[tableView]-|", options: [], metrics:
            nil, views:views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[searchBar]-25-|", options: [], metrics: nil, views:views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[stats]-25-|", options: [], metrics: nil, views:views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tableView]-|", options: [], metrics: nil, views:views)
        
        NSLayoutConstraint.activate(constraints)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "hitCell")
        hitsTableView = tableView
        
        // Add all widgets to InstantSearch
        InstantSearch.reference.addAllWidgets(in: self.view)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
        
        cell.textLabel?.text = hit["name"] as? String
        cell.detailTextLabel?.text = String(hit["salePrice"] as! Double)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

