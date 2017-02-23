//
//  FilterViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 23/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
        
        cell.textLabel?.text = "Hi"
        
        let mySwitch = UISlider(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        mySwitch.maximumValue = 50
        mySwitch.minimumValue = 0
        mySwitch.value = 25
        var control = UIControl()
        control = mySwitch
        cell.accessoryView = control
        
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
