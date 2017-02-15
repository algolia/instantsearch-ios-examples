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
        
        form +++ Section("Section1")
            <<< TextRow() { row in
                row.title = "Row Title"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow() {
                $0.title = "Phone Row"
                $0.placeholder = "Add numbers here"
            }
            +++ Section("Sectoin2")
            <<< DateRow() {
                $0.title = "Date Riw"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
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
