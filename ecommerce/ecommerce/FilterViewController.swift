//
//  FilterViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 15/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearchCore
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
    
    var searcher: Searcher?
    var didDismiss: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupResultButton()
        
        form
            +++ Section()
            <<< ButtonRow(FilterSectionTitles.noTitle) { button in
                button.title = FilterRowTitles.clearAll
            }.onCellSelection { _, _ in
                self.resetAllFiltersWith(form: self.form)
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
            +++ Section(FilterSectionTitles.noTitle)
    }
    
    func setupResultButton() {
        let button = UIButton(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50))
        button.backgroundColor = ColorConstants.barBackgroundColor
        button.setTitle("100 Results", for: .normal)
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem?.target = self
        navigationItem.leftBarButtonItem?.action = #selector(cancelClicked(_:))
        navigationItem.leftBarButtonItem?.tintColor = ColorConstants.barTextColor
        
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(searchClicked(_:))
        navigationItem.rightBarButtonItem?.tintColor = ColorConstants.barTextColor
        
        navigationController?.navigationBar.barTintColor = ColorConstants.barBackgroundColor
        //navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorConstants.barTextColor]
    }
    
    func buttonClicked() {
        print("Button Clicked")
    }
    
    // TODO: Need to find a better way to clear all of these. for .. in self.form.values() was not working, so invetigate more there.
    // Also there is a bug in the Eureka library leading to weird slider row placement, hence the temp fix of assigning a value of 0.
    func resetAllFiltersWith(form: Form) {
        let minimumOriginalPrice: SliderRow! = self.form.rowBy(tag: FilterTags.minimumOriginalPrice)
        minimumOriginalPrice.value = 0.0
        minimumOriginalPrice.reload()
        
        let maximumOriginalPrice: SliderRow! = self.form.rowBy(tag: FilterTags.maximumOriginalPrice)
        maximumOriginalPrice.value = 0.0
        maximumOriginalPrice.reload()
        
        let minimumPromotedPrice: StepperRow! = self.form.rowBy(tag: FilterTags.minimumPromotedPrice)
        minimumPromotedPrice.value = nil
        minimumPromotedPrice.reload()
        
        let maximumPromotedPrice: StepperRow! = self.form.rowBy(tag: FilterTags.maximumPromotedPrice)
        maximumPromotedPrice.value = nil
        maximumPromotedPrice.reload()
        
        let hasDiscount: CheckRow! = self.form.rowBy(tag: FilterTags.hasDiscount)
        hasDiscount.value = nil
        hasDiscount.reload()
        
        let hasFreeShipping: SwitchRow! = self.form.rowBy(tag: FilterTags.hasFreeShipping)
        hasFreeShipping.value = nil
        hasFreeShipping.reload()
        
        let minimumReviews: IntRow! = self.form.rowBy(tag: FilterTags.minimumReviews)
        minimumReviews.value = nil
        minimumReviews.reload()
        
        let ratings: SegmentedRow<String>! = self.form.rowBy(tag: FilterTags.ratings)
        ratings.value = nil
        ratings.reload()
        
        searcher?.params.clearNumericRefinements()
    }
    
    func cancelClicked(_ barButtonItem: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func searchClicked(_ barButtonItem: UIBarButtonItem) {
        let allValues = form.values()
        
        if let minimumOriginalPrice = allValues[FilterTags.minimumOriginalPrice] as? Float {
            if minimumOriginalPrice >= 1 {
                searcher?.params.addNumericRefinement("salePrice", .greaterThanOrEqual, Double(minimumOriginalPrice))
            }
        }
        
        if let maximumOriginalPrice = allValues[FilterTags.maximumOriginalPrice] as? Float {
            if maximumOriginalPrice >= 1 {
                searcher?.params.addNumericRefinement("salePrice", .lessThanOrEqual, Double(maximumOriginalPrice))
            }
        }
        
        if let minimumReviews = allValues[FilterTags.minimumReviews] as? Int {
            searcher?.params.addNumericRefinement("customerReviewCount", .greaterThanOrEqual, Int(minimumReviews))
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
        didDismiss?()
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
