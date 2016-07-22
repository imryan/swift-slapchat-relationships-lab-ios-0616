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
    let store = DataStore.sharedDataStore
    
    // MARK: - Functions
    
    @IBAction func addPerson() {
        let alertController = UIAlertController(title: "Slapchat", message: "Add a new contact", preferredStyle: .Alert)
        var field: UITextField!
        
        let send = UIAlertAction(title: "Add", style: .Default) { (action) in
            self.store.addPerson(field.text!)
            self.reload()
        }
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            textField.placeholder = "John Doe"
            textField.returnKeyType = .Done
            
            field = textField
        })
        
        alertController.addAction(send)
        alertController.addAction(dismiss)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func reload() {
        store.fetchData()
        recipients = store.recipients
        
        tableView.reloadSections(NSIndexSet.init(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: .Automatic)
    }
    
    // MARK: - Table
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "People"
    }
    
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
            cell.detailTextLabel?.text = (count == 1) ? "\(count) message" : "\(count) messages"
        }
        
        return cell
    }
    
    // MARK: - View
    
    override func viewWillAppear(animated: Bool) {
        store.fetchData()
        recipients = store.recipients
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ToMessages") {
            let messagesViewController = segue.destinationViewController as! TableViewController
            
            if let index = tableView.indexPathForSelectedRow?.row {
                messagesViewController.recipient = recipients[index]
            }
        }
    }
}
