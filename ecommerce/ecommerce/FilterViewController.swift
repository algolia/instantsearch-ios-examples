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
        
        form +++ Section("Original Price")
            <<< SliderRow { slider in
                slider.title = "Minimum Price"
                slider.value = 1
                slider.minimumValue = 1
                slider.maximumValue = 100 // TODO: Set correct values
            }
            <<< SliderRow() { slider in
                slider.title = "Maximum Price"
                slider.value = 100
                slider.maximumValue = 1
                slider.maximumValue = 100
            }
            +++ Section("Promoted Price")
            <<< StepperRow { stepper in
                stepper.title = "Minimum Price"
                stepper.value = 1
            }
            <<< StepperRow() { stepper in
                stepper.title = "Maximum Price"
                stepper.value = 100
            }
            +++ Section("Perks")
            <<< CheckRow() { check in
                check.title = "Has Discount?"
                check.value = false
            }
            <<< SwitchRow() { check in
                check.title = "Free Shipping?"
                check.value = false
            }
            +++ Section("Quality")
            <<< IntRow() { intRow in
                intRow.title = "Minimum number of reviews"
                intRow.value = 0
            }
        
    }
    
    func cancelClicked(_ barButtonItem: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func searchClicked(_ barButtonItem: UIBarButtonItem) {
        // TODO: Save the filters here before exiting!
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
