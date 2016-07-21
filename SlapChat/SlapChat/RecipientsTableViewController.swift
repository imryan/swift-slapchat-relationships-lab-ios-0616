//
//  RecipientsTableViewController.swift
//  SlapChat
//
//  Created by Ryan Cohen on 7/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class RecipientsTableViewController: UITableViewController {

    var recipients: [Recipient] = []
    let dataStore = DataStore.sharedDataStore
    
    // MARK: - Table
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipients.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellId", forIndexPath: indexPath)
        
        let recipient = recipients[indexPath.row]
        
        cell.textLabel?.text = recipient.name

        if let count = recipient.messages?.count {
            cell.detailTextLabel?.text = "\(count) messages"
        } else {
            cell.detailTextLabel?.text = "No messages"
        }
        
        return cell
    }
    
    // MARK: View
    
    override func viewWillAppear(animated: Bool) {
        dataStore.fetchData()
        recipients = dataStore.recipients
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let messagesViewController = segue.destinationViewController as! TableViewController
        
        if let index = tableView.indexPathForSelectedRow?.row {
            messagesViewController.recipient = recipients[index]
        }
    }
}
