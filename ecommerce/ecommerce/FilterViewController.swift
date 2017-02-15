//
//  FilterViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 15/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import Eureka

class FilterViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.target = self
        navigationItem.leftBarButtonItem?.action = #selector(cancelClicked(_:))
        
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(searchClicked(_:))
        
        form
            +++ Section()
            <<< ButtonRow() { button in
                button.title = "Clear all filters"
            }.onCellSelection { cell, row in
                
            }
            +++ Section("Original Price")
            <<< SliderRow("MinimumOriginalPrice") { slider in
                slider.title = "Minimum Price"
                slider.value = 0
                slider.minimumValue = 1
                slider.maximumValue = 100 // TODO: Set correct values
            }
            <<< SliderRow("MaximumOriginalPrice") { slider in
                slider.title = "Maximum Price"
                slider.value = 0
                slider.maximumValue = 1
                slider.maximumValue = 100
            }
            +++ Section("Promoted Price")
            <<< StepperRow("MinimumPromotedPrice") { stepper in
                stepper.title = "Minimum Price"
            }
            <<< StepperRow("MaximumPromotedPrice") { stepper in
                stepper.title = "Maximum Price"
            }
            +++ Section("Perks")
            <<< CheckRow("HasDiscount") { check in
                check.title = "Has Discount?"
            }
            <<< SwitchRow("HasFreeShipping") { check in
                check.title = "Free Shipping?"
            }
            +++ Section("Quality")
            <<< IntRow("MinimumReviews") { intRow in
                intRow.title = "Minimum number of reviews"
            }
            <<< SegmentedRow<String>("Ratings") { segmentedRow in
                segmentedRow.title = "Ratings"
                segmentedRow.options = ["1", "2", "3", "4", "5"]
            }
        
    }
    
    func cancelClicked(_ barButtonItem: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func searchClicked(_ barButtonItem: UIBarButtonItem) {
        print(form.values())
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
