//
//  RangeSliderViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 6/16/17.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearch
import WARangeSlider

class RangeSliderViewController: UIViewController {
    
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var resultButton: StatsButtonWidget!
    @IBOutlet weak var maxLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InstantSearch.shared.registerAllWidgets(in: self.view)
        LayoutHelpers.setupResultButton(button: resultButton)
        resultButton.addTarget(self, action: #selector(resultButtonClicked), for: .touchUpInside)
        minLabel.text = "\(rangeSlider.lowerValue)$"
        maxLabel.text = "\(rangeSlider.upperValue)$"
    }
    
    func resultButtonClicked() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? ItemTableViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    public func rangeSliderValueChanged() {
        minLabel.text = "\(Int(rangeSlider.lowerValue))$"
        maxLabel.text = "\(Int(rangeSlider.upperValue))$"
    }
}
