//
//  RatingViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 6/16/17.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearch

class RatingViewController: UIViewController {
    
    @IBOutlet weak var resultButton: StatsButtonWidget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InstantSearch.shared.registerAllWidgets(in: self.view)
        setupResultButton()
    }

    func setupResultButton() {
        
        resultButton.backgroundColor = ColorConstants.barBackgroundColor
        resultButton.setTitle("Fetching number of results...", for: .normal)
        resultButton.titleLabel?.textAlignment = .center
        resultButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resultButton.setTitleColor(ColorConstants.barTextColor, for: .normal)
    }
}
