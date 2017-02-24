//
//  FilterViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 23/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var instantSearch: InstantSearch?
    var didDismiss: (() -> ())?
    var controls: [UIControl] = []
    var titles: [String] = ["button", "switch", "slider", "stepper", "segmented"]
    
    let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        setupResultButton()
        
        controls.append(createButton())
        controls.append(createSwitch())
        controls.append(createSlider())
        controls.append(createStepper())
        controls.append(createSegmentedControl())
        
        for (index, control) in controls.enumerated() {
            control.addTarget(self, action: #selector(valueChanged(control:)), for: .valueChanged)
            control.tag = index
        }
    }
    
    func valueChanged(control: UIControl) {
        switch control {
        case let slider as InstantSearchSlider:
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
        instantSearch?.addWidget(stats: resultButton.titleLabel!)
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
    
    private func createSlider() -> InstantSearchSlider {
        let slider = InstantSearchSlider(frame: defaultFrame)
        slider.maximumValue = 50
        slider.minimumValue = 0
        
        return slider
    }
    
    private func createSwitch() -> UISwitch {
        return UISwitch(frame: defaultFrame)
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
