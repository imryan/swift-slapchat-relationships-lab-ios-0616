//
//  SearchViewController.swift
//  SlapChat
//
//  Created by Ryan Cohen on 7/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    enum SearchCase: Int {
        case People = 0
        case Messages = 1
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentBar: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var store = DataStore.sharedDataStore
    var searchCase = SearchCase.People
    var searchResults = []

    // MARK: - Functions
    
    func updateSearchBar() {
        searchResults = []
        reload()
        
        if (segmentBar.selectedSegmentIndex == 0) {
            searchBar.placeholder = "John Doe"
            searchCase = .People
        } else {
            searchBar.placeholder = "What was your address?"
            searchCase = .Messages
        }
    }
    
    func search(query: String) {
        if (searchCase == .People) {
            searchResults = store.fetchPeopleMatching(query)
        } else {
            searchResults = store.fetchMessagesMatching(query)
        }
        
        reload()
    }
    
    func reload() {
        tableView.reloadSections(NSIndexSet.init(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: .Automatic)
    }
    
    // MARK: - Table
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "CellId"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        
        var title: String!
        var detail: String!
        
        if (searchCase == .People) {
            let result: Recipient = searchResults[indexPath.row] as! Recipient
            title = result.name
            
            if let count = result.messages?.count {
                detail = (count == 1) ? "\(count) message" : "\(count) messages"
            }
            
        } else {
            let result: Message = searchResults[indexPath.row] as! Message
            title = result.content
            
            if let name = result.recipient?.name {
                detail = "to \(name)"
            }
        }
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
        
        return cell
    }

    // MARK: - Search Bar
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        search(searchBar.text!)
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.becomeFirstResponder()
        segmentBar.addTarget(self, action: #selector(SearchViewController.updateSearchBar), forControlEvents: .ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
