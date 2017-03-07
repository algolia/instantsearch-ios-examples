//
//  FacetCategoryCell.swift
//  ecommerce
//
//  Created by Guy Daher on 14/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearchCore

class FacetCategoryCell: UITableViewCell {
    
    var facet: FacetValue? {
        didSet {
            guard let facet = facet else { return }
            
            textLabel?.text = facet.value
            detailTextLabel?.text = "\(facet.count)"
        }
    }
    
    var isRefined: Bool = false {
        didSet {
            accessoryType = isRefined ? .checkmark : .none
        }
    }
}
