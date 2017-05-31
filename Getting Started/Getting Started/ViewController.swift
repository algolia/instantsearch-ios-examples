//
//  ViewController.swift
//  Getting Started
//
//  Created by Guy Daher on 31/05/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearch

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Declare your widgets (IB or programatically) in your ViewController
        let searchBar = SearchBarWidget(frame: CGRect(x: 10, y: 10, width: 150, height: 50))
        let statsWidget = StatsLabelWidget(frame: CGRect(x: 10, y: 40, width: 150, height: 50))
        self.view.addSubview(searchBar)
        self.view.addSubview(statsWidget)
        
        // Add all widgets in view to InstantSearch in your ViewController
        InstantSearch.reference.addAllWidgets(in: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

