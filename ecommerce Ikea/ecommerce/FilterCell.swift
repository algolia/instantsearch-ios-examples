//
//  FilterCell.swift
//  ecommerce
//
//  Created by Guy Daher on 23/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    let title = UILabel()
    let control = UIControl()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        control.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        contentView.addSubview(control)
        
        let viewsDict = [
            "title" : title,
            "control": control
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-|", options: .alignAllCenterY, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[control]-|", options: .alignAllCenterY, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[control]-|", options: [], metrics: nil, views: viewsDict))
    }

}
