//
//  RefinementViewController.swift
//  IS-CustomSource
//
//  Created by Guy Daher on 03/04/2018.
//  Copyright © 2018 Robert Mogos. All rights reserved.
//

import Foundation

import UIKit
import InstantSearch
import InstantSearchCore

class RefinementViewController: UIViewController, RefinementTableViewDataSource {
    
    var refinementController: RefinementController!
    var instantSearch: InstantSearch!
    
    lazy var tableView: RefinementTableWidget = {
        let refinementTableWidget = RefinementTableWidget(frame: .zero, style: .plain)
        refinementTableWidget.attribute = "category"
        refinementTableWidget.operator = "and"
        
        return refinementTableWidget
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        tableView.frame = self.view.frame
        self.view.addSubview(tableView)
        refinementController = RefinementController(table: tableView)
        tableView.dataSource = refinementController
        tableView.delegate = refinementController
        refinementController.tableDataSource = self
        instantSearch.registerAllWidgets(in: self.view)
        
        tableView.estimatedRowHeight = 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")
        }
        

        cell!.textLabel?.text = "\(facet) \(count) \(refined)"
        
        return cell!
    }
    
}

