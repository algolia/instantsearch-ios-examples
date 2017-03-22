//
//  ViewController.swift
//  BasicDemo
//
//  Created by Guy Daher on 22/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var instantSearchBinder: InstantSearchBinder = InstantSearchBinder(searcher: AlgoliaSearchManager.instance.searcher)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        instantSearchBinder.addAllWidgets(in: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

