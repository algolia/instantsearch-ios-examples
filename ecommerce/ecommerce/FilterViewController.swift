//
//  FilterViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 23/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearch

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var resultButton: StatsButtonWidget!
    @IBOutlet weak var tableView: UITableView!
    
    var instantSearchPresenter: InstantSearchBinder!
    var didDismiss: (() -> ())?
    var controls: [UIControl] = []
    var titles: [String] = ["button", "switch", "slider", "slider2", "stepper", "segmented"]
    
    let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 40)
    var slider1: SliderWidget!
    var slider2: SliderWidget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        setupResultButton()
        
        slider1 = SliderWidget()
        slider1.attributeName = RefinementParameters.salePrice
        slider1.operation = ">"
        slider1.inclusive = true
        slider1.maximumValue = 50
        slider1.minimumValue = 0
        //slider1?.valueLabel = resultButton.titleLabel!
        
        slider2 = SliderWidget()
        slider2.attributeName = RefinementParameters.salePrice
        slider2.operation = ">"
        slider2.inclusive = true
        slider2.maximumValue = 50
        slider2.minimumValue = 0
        
        controls.append(createButton())
        controls.append(createSwitch())
        controls.append(slider1)
        controls.append(slider2)
        controls.append(createStepper())
        controls.append(createSegmentedControl())
    }
    
    func valueChanged(control: UIControl) {
        switch control {
        case let slider as UISlider:
            let cell = tableView.cellForRow(at: IndexPath(row: slider.tag, section: 0))
            cell?.detailTextLabel?.text = "\(slider.value)"
        default: print("none!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //instantSearch?.addWidget(stats: resultButton.titleLabel!)
//        instantSearch?.addWidget(numericControl: controls[2], withFilterName: RefinementParameters.salePrice, operation: .greaterThanOrEqual)
//        instantSearch?.addWidget(numericControl: controls[3], withFilterName: RefinementParameters.salePrice, operation: .lessThan)
        
        instantSearchPresenter.addAllWidgets(in: self.view)
        // let stats = Stats(label: resultButton.titleLabel!)
        //slider1 = SliderWidget(attributeName: RefinementParameters.salePrice, operation: .greaterThanOrEqual)
        
        for (index, control) in controls.enumerated() {
            control.addTarget(self, action: #selector(valueChanged(control:)), for: .valueChanged)
            control.tag = index
        }
        
        
        //instantSearchPresenter?.addWidget(facetControl: controls[1], withFilterName: RefinementParameters.promoted)
    }
    
    func setupResultButton() {
        
        resultButton.backgroundColor = ColorConstants.barBackgroundColor
        resultButton.setTitle("Fetching number of results...", for: .normal)
        resultButton.titleLabel?.textAlignment = .center
        resultButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resultButton.setTitleColor(ColorConstants.barTextColor, for: .normal)
        resultButton.addTarget(self, action: #selector(self.searchClicked(_:)), for: .touchUpInside)
    }
    
    func searchClicked(_ barButtonItem: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
        didDismiss?()
    }
    
    private func createSlider() -> UISlider {
        let slider = UISlider(frame: defaultFrame)
        slider.maximumValue = 50
        slider.minimumValue = 0
        
        return slider
    }
    
    private func createSlider2() -> UISlider {
        let slider = UISlider(frame: defaultFrame)
        slider.maximumValue = 50
        slider.minimumValue = 0
        
        return slider
    }
    
    private func createSwitch() -> UISwitch {
        let mySwitch = UISwitch(frame: defaultFrame)
        return mySwitch
    }
    
    private func createStepper() -> UIStepper {
        let stepper = UIStepper(frame: defaultFrame)
        stepper.stepValue = 1
        
        return stepper
    }
    
    private func createSegmentedControl() -> UISegmentedControl {
        let items = ["one", "two", "three"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.frame = CGRect(x: 10, y: 10, width: 200, height: 30)
        return segmentedControl
        
    }
    
    private func createButton() -> UIButton {
        let button = UIButton(frame: defaultFrame)
        button.backgroundColor = UIColor.red
        button.setTitle("clear", for: .normal)
        //instantSearch?.addWidget(clearFilter: button, for: .touchUpInside)
        return button
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
        
        cell.detailTextLabel?.text = "text"
        cell.textLabel?.text = titles[indexPath.row]
        cell.accessoryView = controls[indexPath.row]
        
        return cell
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
