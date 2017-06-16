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
    
    var facet: String? {
        didSet {
            guard let facet = facet else { return }
            textLabel?.text = facet
        }
    }
    
    var count: Int? {
        didSet {
            guard let count = count else { return }
            detailTextLabel?.text = "\(count)"
        }
    }
    
    var isRefined: Bool = false {
        didSet {
            accessoryType = isRefined ? .checkmark : .none
        }
    }
}
