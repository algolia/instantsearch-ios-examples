//
//  RefinementViewController.swift
//  Getting Started Storyboard
//
//  Created by Guy Daher on 01/06/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearch

class RefinementViewController: UIViewController, RefinementTableViewDataSource {
    
    @IBOutlet weak var tableView: RefinementTableWidget!
    var refinementController: RefinementController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refinementController = RefinementController(table: tableView)
        tableView.dataSource = refinementController
        tableView.delegate = refinementController
        refinementController.tableDataSource = self
        // refinementController.tableDelegate = self
        
        InstantSearch.shared.register(widget: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "refinementCell", for: indexPath)
        
        cell.textLabel?.text = facet
        cell.detailTextLabel?.text = String(count)
        cell.accessoryType = refined ? .checkmark : .none
        
        return cell
    }
}


