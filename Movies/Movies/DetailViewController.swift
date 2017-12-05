//
//  DetailViewController.swift
//  Movies
//
//  Created by Guy Daher on 04/12/2017.
//  Copyright © 2017 Algolia. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore

class DetailViewControllerDemo: HitsTableViewController {
    
    var indexName: IndexName = .movies
    var query: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        InstantSearch.shared.register(searchController: searchController)
        self.navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        
        hitsTableView = HitsTableWidget(frame: self.view.bounds)
        hitsTableView.indexName = indexName.description
        hitsTableView.indexId = "detail"
        hitsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailsCell")

        self.view.addSubview(hitsTableView)
        InstantSearch.shared.registerAllWidgets(in: self.view, doSearch: false)
        
        // This will automatically trigger an Algolia search, that's why we
        // specify doSearch: false above.
        searchController.searchBar.text = query
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath)
        cell.textLabel?.text = getName(hit: hit)
        cell.textLabel?.highlightedText = getHighlightedText(hit: hit)
        cell.textLabel?.highlightedTextColor = UIColor.black
        cell.textLabel?.highlightedBackgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 100 / 255, alpha: 1)
        if let imageUrl = getImagePath(hit: hit) {
            cell.imageView?.contentMode = .scaleAspectFit
            cell.imageView?.setImageWith(imageUrl, placeholderImage: UIImage(named: "placeholder"))
        } else {
            cell.imageView?.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String : Any]) {
        print("Entry clicked")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func getName(hit: [String: Any]) -> String {
        switch indexName {
        case .movies:
            return hit["title"] as? String ?? ""
        case .actors:
            return hit["name"] as? String ?? ""
        }
    }
    
    func getHighlightedText(hit: [String: Any]) -> String {
        switch indexName {
        case .movies:
            return SearchResults.highlightResult(hit: hit, path: "title")?.value ?? ""
        case .actors:
            return SearchResults.highlightResult(hit: hit, path: "name")?.value ?? ""
        }
    }
    
    func getImagePath(hit: [String: Any]) -> URL? {
        switch indexName {
        case .movies:
            if let image = hit["image"] as? String, let imageUrl = URL(string: image) {
                return imageUrl
            }
            
            return nil
        case .actors:
            if let image = hit["image_path"] as? String, let imageUrl = URL(string: "https://image.tmdb.org/t/p/w300" + image) {
                return imageUrl
            }
            
            return nil
        }
    }
}

enum IndexName {
    case movies
    case actors
    
    var description : String {
        switch self {
        case .movies: return "movies";
        case .actors: return "actors";
        }
    }
}
