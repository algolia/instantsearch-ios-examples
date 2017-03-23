//
//  FacetController.swift
//  BasicDemo
//
//  Created by Guy Daher on 23/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

class FacetController: UIViewController, FacetDataSource {
    
    var instantSearchBinder: InstantSearchBinder!
    @IBOutlet weak var refinementList: RefinementListWidget!
    
    override func viewDidLoad() {
        refinementList.facetDataSource = self
        instantSearchBinder.add(widget: refinementList)
    }
    
    func cellFor(facetValue: FacetValue, isRefined: Bool, at indexPath: IndexPath) -> UITableViewCell {
        let cell = refinementList.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath)
        
        cell.textLabel?.text = facetValue.value
        cell.detailTextLabel?.text = String(facetValue.count)
        cell.accessoryType = isRefined ? .checkmark : .none
        
        return cell
    }
}
