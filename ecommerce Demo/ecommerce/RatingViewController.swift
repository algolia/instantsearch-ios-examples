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
        LayoutHelpers.setupResultButton(button: resultButton)
        resultButton.addTarget(self, action: #selector(resultButtonClicked), for: .touchUpInside)
    }
    
    @objc func resultButtonClicked() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? ItemTableViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
