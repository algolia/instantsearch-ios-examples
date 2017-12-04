//
//  ViewController.swift
//  Movies
//
//  Created by Guy Daher on 04/12/2017.
//  Copyright © 2017 Algolia. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore
import AFNetworking

class ViewController: MultiHitsTableViewController {
    
    @IBOutlet weak var tableView: MultiHitsTableWidget!
    @IBOutlet weak var searchBar: TextFieldWidget!
    
    var hitsController: MultiHitsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        InstantSearch.shared.registerAllWidgets(in: self.view)
        
        hitsTableViews = [tableView]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
       let cell: Cell!

        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
            cell.nameLabel.text = hit["name"] as? String
            cell.nameLabel.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
            cell.nameLabel.highlightedTextColor = UIColor.black
            cell.nameLabel.highlightedBackgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 100 / 255, alpha: 1)
            if let image = hit["image_path"] as? String, let imageUrl = URL(string: "https://image.tmdb.org/t/p/w300" + image) {
                cell.imageViewCell.contentMode = .scaleAspectFit
                cell.imageViewCell.setImageWith(imageUrl, placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.imageView?.image = UIImage(named: "placeholder")
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
            cell.nameLabel.text = hit["title"] as? String
            cell.nameLabel.highlightedText = SearchResults.highlightResult(hit: hit, path: "title")?.value
            cell.nameLabel.highlightedTextColor = UIColor.black
            cell.nameLabel.highlightedBackgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 100 / 255, alpha: 1)
            if let image = hit["image"] as? String, let imageUrl = URL(string: image) {
                cell.imageViewCell.contentMode = .scaleAspectFit
                cell.imageViewCell.setImageWith(imageUrl, placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.imageViewCell.image = UIImage(named: "placeholder")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 30))
        label.textColor = UIColor.white
        
            if section == 0 {
                label.text = "Actors"
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

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        if section == 0 {
            button.setTitle("Load more Actors >", for: .normal)
            button.tag = 0
        } else {
            button.setTitle("Load more Movies >", for: .normal)
            button.tag = 1
        }

        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(loadMoreButtonTapped(sender:)), for: .touchUpInside)
        footerView.addSubview(button)

        return footerView
    }

    @objc func loadMoreButtonTapped(sender: UIButton) {
        if sender.tag == 0 {
            let detailVC = DetailViewControllerDemo(nibName: "DetailViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("results button clicked")
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}
