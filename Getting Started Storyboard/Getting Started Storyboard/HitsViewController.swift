//
//  HitsViewController.swift
//  Getting Started Storyboard
//
//  Created by Guy Daher on 01/06/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore

class HitsViewController: MultiHitsTableViewController {

    @IBOutlet weak var tableView: MultiHitsTableWidget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hitsTableView = tableView
        
        InstantSearch.shared.registerAllWidgets(in: self.view)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
        
        if indexPath.section == 0 { // bestbuy
            cell.textLabel?.highlightedTextColor = .blue
            cell.textLabel?.highlightedBackgroundColor = .yellow
            cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        } else { // bestbuy promo
            cell.textLabel?.highlightedTextColor = .white
            cell.textLabel?.highlightedBackgroundColor = .black
            cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        
        let view = UIView()
        view.addSubview(label)
        view.backgroundColor = UIColor.gray
        return view
    }
}

