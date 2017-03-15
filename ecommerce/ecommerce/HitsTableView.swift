//
//  HitsTableView.swift
//  ecommerce
//
//  Created by Guy Daher on 15/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

public class HitsTableView: UITableView, AlgoliaWidget {
    
    var searcher: Searcher!
    var hitDataSource: AlgoliaTableHitDataSource?
    
    public weak var tableDataSource: AlgoliaTableViewDataSource?
    
    @objc func initWith(searcher: Searcher) {
        self.searcher = searcher
        self.dataSource = self
        
        if searcher.hits != nil {
            reloadData()
        }
    }
    
    @objc func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        // TODO: Work on that...
        if searcher.hits != nil {
            reloadData()
        }
        
        // TODO: Use that efficiently
        //hits.scrollToFirstRow()
    }
    
    func loadMoreIfNecessary(rowNumber: Int) {
        guard let hits = searcher.hits else { return }
        if rowNumber + 5 >= hits.count {
            searcher.loadMore()
        }
    }
    
    @objc func onReset() {
        
    }
}

extension HitsTableView: UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableDataSource = self.tableDataSource {
            let result = tableDataSource.tableView?(tableView, numberOfRowsInSection: section)
            if let result = result { return result }
        }
    
        return searcher.hits?.count ?? 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadMoreIfNecessary(rowNumber: indexPath.row)
        
        if let tableDataSource = self.tableDataSource {
            let result = tableDataSource.tableView?(tableView, cellForRowAt: indexPath)
            if let result = result { return result }
        }
        
        
        if let hits = searcher.hits, let hitDataSource = hitDataSource, indexPath.row < hits.count {
            return hitDataSource.tableView(tableView, cellForRowAt: indexPath, withHit: hits[indexPath.row])
        }
        
        return UITableViewCell()
    }
    
    
    @available(iOS 2.0, *)
    public func numberOfSections(in tableView: UITableView) -> Int { // Default is 1 if not implemented
        return self.tableDataSource?.numberOfSections?(in: tableView) ?? 1
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { // fixed font style. use custom view (UILabel) if you want something different
        return tableDataSource?.tableView?(tableView, titleForHeaderInSection: section)
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return tableDataSource?.tableView?(tableView, titleForHeaderInSection: section)
    }
    
    
    // Editing
    
    // Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableDataSource?.tableView?(tableView, canEditRowAt: indexPath) ?? true
    }
    
    
    // Moving/reordering
    
    // Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return tableDataSource?.tableView?(tableView, canMoveRowAt: indexPath) ?? false
    }
    
    
    // Index
    
    @available(iOS 2.0, *)
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? { // return list of section titles to display in section index view (e.g. "ABCD...Z#")
        return tableDataSource?.sectionIndexTitles?(for: tableView)
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int { // tell table which section corresponds to section title/index (e.g. "B",1))
        return tableDataSource?.tableView?(tableView, sectionForSectionIndexTitle: title, at: index) ?? index
    }
    
    // Data manipulation - insert and delete support
    
    // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
    // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableDataSource?.tableView?(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    
    // Data manipulation - reorder / moving support
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tableDataSource?.tableView?(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}

@objc public protocol AlgoliaTableViewDataSource {
    @objc @available(iOS 2.0, *)
    optional func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @objc @available(iOS 2.0, *)
    optional func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    
    @objc @available(iOS 2.0, *)
    optional func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
    
    
    @objc @available(iOS 2.0, *)
    optional func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? // fixed font style. use custom view (UILabel) if you want something different
    
    @objc @available(iOS 2.0, *)
    optional func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    
    
    // Editing
    
    // Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
    @objc @available(iOS 2.0, *)
    optional func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    
    
    // Moving/reordering
    
    // Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
    @objc @available(iOS 2.0, *)
    optional func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    
    
    // Index
    
    @objc @available(iOS 2.0, *)
    optional func sectionIndexTitles(for tableView: UITableView) -> [String]? // return list of section titles to display in section index view (e.g. "ABCD...Z#")
    
    @objc @available(iOS 2.0, *)
    optional func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int // tell table which section corresponds to section title/index (e.g. "B",1))
    
    
    // Data manipulation - insert and delete support
    
    // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
    // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
    @objc @available(iOS 2.0, *)
    optional func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    
    
    // Data manipulation - reorder / moving support
    
    @objc @available(iOS 2.0, *)
    optional func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    
}
