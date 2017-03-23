import UIKit
import InstantSearchCore

class ViewController: UIViewController, HitDataSource, FacetDataSource {
    @IBOutlet weak var hitsTable: HitsTableWidget!
    @IBOutlet weak var refinementList: RefinementListWidget!
    
    var instantSearchBinder: InstantSearchBinder!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsTable.hitDataSource = self
        refinementList.facetDataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        instantSearchBinder = InstantSearchBinder(searcher: AlgoliaSearchManager.instance.searcher, view: self.view)
    }
    
    func cellFor(hit: [String : Any], at indexPath: IndexPath) -> UITableViewCell {
        let cell = hitsTable.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
        
        cell.textLabel?.text = hit["name"] as? String
        cell.detailTextLabel?.text = String(hit["salePrice"] as! Double)
        
        return cell
    }
    
    func cellFor(facetValue: FacetValue, isRefined: Bool, at indexPath: IndexPath) -> UITableViewCell {
        let cell = refinementList.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath)
        
        cell.textLabel?.text = facetValue.value
        cell.detailTextLabel?.text = String(facetValue.count)
        cell.accessoryType = isRefined ? .checkmark : .none
        
        return cell
    }
}
