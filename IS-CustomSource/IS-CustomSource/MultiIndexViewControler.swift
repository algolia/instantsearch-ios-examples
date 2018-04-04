//
//  ViewController.swift
//  IS-CustomSource
//
//  Created by Robert Mogos on 06/10/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore

class MultiIndexViewController: MultiHitsTableViewController {

    lazy var tableView: MultiHitsTableWidget = {
       MultiHitsTableWidget(frame: .zero, style: .plain)
    }()
  var instantSearch: InstantSearch!
  var searchBar: SearchBarWidget!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar = SearchBarWidget(frame: .zero)
    
    self.navigationItem.titleView = searchBar
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(onFiltersTapped))
    self.edgesForExtendedLayout = []
    tableView.frame = self.view.frame
    self.view.addSubview(tableView)
    configureInstantSearch()
    
    hitsTableViews = [tableView]
    
    tableView.estimatedRowHeight = 80
  }
    
    @objc func onFiltersTapped() {
        let refinementViewController = RefinementViewController()
        refinementViewController.instantSearch = instantSearch
        self.navigationController?.pushViewController(refinementViewController, animated: true)
    }
  
  func configureInstantSearch() {
    
    // Initialising an Index
    
    //let index = CustomSearchableImplementation()
    //let index = ElasticImplementation()
    let productSearchable = CustomBackendProducts()
    let movieSearchable = CustomBackendMovies()
    
    tableView.indices = "products,movie"
    instantSearch = InstantSearch.init(searchables: [productSearchable, movieSearchable], searcherIds: [SearcherId(index: "products"), SearcherId(index: "movie")])
    instantSearch.registerAllWidgets(in: self.view)
    instantSearch.register(widget: searchBar)
//    instantSearch.searcher.params.addFacetRefinement(name: "category", value: "someCat")
//    instantSearch.searcher.params.addNumericRefinement("price", .greaterThanOrEqual, 20)
  }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 30))
        label.textColor = UIColor.white
        
        if section == 0 {
            label.text = "Products"
        } else {
            label.text = "Movies"
        }
        
        
        let view = UIView()
        view.addSubview(label)
        view.backgroundColor = UIColor.gray
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String: Any]) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
    if cell == nil {
        cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")
    }
    
    let text: String!
    
    if indexPath.section == 0 {
        text = hit["name"] as! String
    } else {
        text = hit["title"] as! String
    }
    
    //let name = hit["title"] as! String
    
    
    cell!.textLabel?.text = text
    //cell!.detailTextLabel?.text = location
    
    return cell!
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

