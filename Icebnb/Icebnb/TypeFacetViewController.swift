//
//  TypeFacetViewController.swift
//  Icebnb
//
//  Created by Robert Mogos on 07/09/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore
import KUIPopOver

class TypeFacetViewController: UIViewController, RefinementTableViewDataSource {
  
  @IBOutlet weak var tableViewWidget: RefinementTableWidget!
  var refinementController: RefinementController!
  
  override func viewDidLoad() {
    tableViewWidget.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "facetCell")
    super.viewDidLoad()
    tableViewWidget.attribute = "room_type"
    refinementController = RefinementController(table: tableViewWidget)
    tableViewWidget.dataSource = refinementController
    tableViewWidget.delegate = refinementController
    refinementController.tableDataSource = self
    InstantSearch.shared.registerAllWidgets(in: self.view)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath,
                 containing facet: String,
                 with count: Int,
                 is refined: Bool) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath)
    cell.textLabel?.text = facet
    cell.detailTextLabel?.text = String(count)
    cell.accessoryType = refined ? .checkmark : .none
    return cell
  }
}

extension TypeFacetViewController: KUIPopOverUsable {
  var contentSize: CGSize {
    get {
      // TODO: This is a hack, we should open the viewModel instead
      var nbOfRows:CGFloat = 5
      if refinementController != nil {
        nbOfRows = CGFloat(refinementController.tableView(tableViewWidget, numberOfRowsInSection: 0))
        
      }
      let size = CGSize(width: PopoverConstants.popoverWidth,
                        height: PopoverConstants.popoverCellHeight * nbOfRows)
      return size
    }
  }
  var contentView: UIView {
    get {
      return self.view
    }
  }
  
  var arrowDirection: UIPopoverArrowDirection {
    get {
      return .up
    }
  }
}
