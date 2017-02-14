//
//  FacetCategoryCell.swift
//  ecommerce
//
//  Created by Guy Daher on 14/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

class FacetCategoryCell: UITableViewCell {
    
    var facet: FacetRecord? {
        didSet {
            guard let facet = facet else { return }
            
            textLabel?.text = facet.value
            detailTextLabel?.text = "\(facet.count ?? 0)"
            accessoryType = facet.isRefined ? .checkmark : .none
        }
    }
}
