//
//  FilterViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 15/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import Eureka

struct FilterTags {
    static let minimumOriginalPrice = "MinimumOriginalPrice"
    static let maximumOriginalPrice = "MaximumOriginalPrice"
    static let minimumPromotedPrice = "MinimumPromotedPrice"
    static let maximumPromotedPrice = "MaximumPromotedPrice"
    static let hasDiscount = "HasDiscount"
    static let hasFreeShipping = "HasFreeShipping"
    static let minimumReviews = "MinimumReviews"
    static let ratings = "Ratings"
}

struct FilterSectionTitles {
    static let noTitle = ""
    static let originalPrice = "Original Price"
    static let promotedPrice = "Promoted Price"
    static let perks = "Perks"
    static let quality = "Quality"
}

struct FilterRowTitles {
    static let clearAll = "Clear all filters"
    static let minimumPrice = "Minimum Price"
    static let maximumPrice = "Maximum Price"
    static let hasDiscount = "Has Discount?"
    static let freeShipping = "Free Shipping?"
    static let minimumReviews = "Minimum number of reviews"
    static let ratings = "Ratings"
}

class FilterViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.target = self
        navigationItem.leftBarButtonItem?.action = #selector(cancelClicked(_:))
        
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(searchClicked(_:))
        
        form
            +++ Section()
            <<< ButtonRow(FilterSectionTitles.noTitle) { button in
                button.title = FilterRowTitles.clearAll
            }.onCellSelection { cell, row in
                print((self.form.rowBy(tag: "MinimumOriginalPrice") as? SliderRow)?.value)
                (self.form.rowBy(tag: "MinimumOriginalPrice") as? SliderRow)?.value = 5.0
                (self.form.rowBy(tag: "MinimumOriginalPrice") as? SliderRow)?.reload()
            }
            +++ Section(FilterSectionTitles.originalPrice)
            <<< SliderRow(FilterTags.minimumOriginalPrice) { slider in
                slider.title = FilterRowTitles.minimumPrice
                slider.value = 0
                slider.minimumValue = 1
                slider.maximumValue = 100 // TODO: Set correct values
            }
            <<< SliderRow(FilterTags.maximumOriginalPrice) { slider in
                slider.title = FilterRowTitles.maximumPrice
                slider.value = 0
                slider.maximumValue = 1
                slider.maximumValue = 100
            }
            +++ Section(FilterSectionTitles.promotedPrice)
            <<< StepperRow(FilterTags.minimumPromotedPrice) { stepper in
                stepper.title = FilterRowTitles.minimumPrice
            }
            <<< StepperRow(FilterTags.maximumPromotedPrice) { stepper in
                stepper.title = FilterRowTitles.maximumPrice
            }
            +++ Section(FilterSectionTitles.perks)
            <<< CheckRow(FilterTags.hasDiscount) { check in
                check.title = FilterRowTitles.hasDiscount
            }
            <<< SwitchRow(FilterTags.hasFreeShipping) { check in
                check.title = FilterRowTitles.freeShipping
            }
            +++ Section(FilterSectionTitles.quality)
            <<< IntRow(FilterTags.minimumReviews) { intRow in
                intRow.title = FilterRowTitles.minimumReviews
            }
            <<< SegmentedRow<String>(FilterTags.ratings) { segmentedRow in
                segmentedRow.title = FilterRowTitles.ratings
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
