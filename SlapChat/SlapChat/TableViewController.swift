//
//  TableViewController.swift
//  SlapChat
//
//  Created by Flatiron School on 7/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var messages: [Message] = []
    var recipient: Recipient!
    
    let store = DataStore.sharedDataStore
    let dateFormatter = NSDateFormatter()
    
    // MARK: - Functions
    
    @IBAction func add() {
        let alertController = UIAlertController(title: "Slapchat", message: "Send a message to \(recipient.name!)", preferredStyle: .Alert)
        var field: UITextField!
        
        let send = UIAlertAction(title: "Send", style: .Default) { (action) in
            self.store.sendMessage(field.text!, recipient: self.recipient)
            self.reload()
        }
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            textField.placeholder = "Hello!"
            textField.returnKeyType = .Done
            
            field = textField
        })
        
        alertController.addAction(send)
        alertController.addAction(dismiss)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func reload() {
        store.fetchData()
        
        for message in recipient.messages! {
            if (!messages.contains(message)) {
                messages.append(message)
            }
        }
        
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        messages = (messages as NSArray).sortedArrayUsingDescriptors([sort]) as! [Message]
        
        tableView.reloadSections(NSIndexSet.init(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: .Automatic)
    }
    
    // MARK: - Table
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Messages"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellId", forIndexPath: indexPath)
        
        let message = messages[indexPath.row]
        
        cell.textLabel?.text = message.content
        
        if let createdAt = message.createdAt {
            cell.detailTextLabel?.text = "\(dateFormatter.stringFromDate(createdAt))"
        }
        
        return cell
    }
    
    // MARK: - View
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        dateFormatter.dateFormat = "h:mm a"
        reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = recipient.name {
            self.title = "\(name)"
        } else {
            self.title = "Messages"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}