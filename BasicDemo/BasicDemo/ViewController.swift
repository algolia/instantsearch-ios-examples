import UIKit
import InstantSearchCore

class ViewController: UIViewController, HitDataSource {
    @IBOutlet weak var hitsTable: HitsTableWidget!
    
    var instantSearchBinder: InstantSearchBinder!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsTable.hitDataSource = self
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let facetController = segue.destination as! FacetController
        facetController.instantSearchBinder = instantSearchBinder
    }
}
