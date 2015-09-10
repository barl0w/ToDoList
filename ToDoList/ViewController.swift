//
//  ViewController.swift
//  ToDoList
//
//  Created by Scott Barlow on 8/22/15.
//  Copyright © 2015 Scott Barlow. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tField : UITextField!
    
    var complete : Bool!
    
    var items : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // MARK: - Load from CoreData upon launch:
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let request = NSFetchRequest(entityName: "Item")
        
        var results : [AnyObject]?
        
        do {
            
            results = try context.executeFetchRequest(request)
            
        } catch _ {
            
            results = nil
            
        }
        
        if results != nil {
            
            self.items = results as! [Item]
            
        }
        
        self.tableView.reloadData()
    }
    
    func configureTextField(textField: UITextField) {
        
        textField.placeholder = "Enter New Item"
        textField.textAlignment = .Center
        
        self.tField = textField
        
    }
    
    // MARK: - "+" sign when clicked, do the following:

    @IBAction func addToDoItem(sender: AnyObject) {
        
        alertPopUp()
        
    }
    
    // MARK: - Save the new item to CoreData:
    
    func saveNewItem() {
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
        
        item.title = tField.text
        item.completed = false
        
        do {
            
            try context.save()
            
        } catch _ {
            
            // Do nothing
            
        }
        
        let request = NSFetchRequest(entityName: "Item")
        
        var results : [AnyObject]?
        
        do {
            
            results = try context.executeFetchRequest(request)
            
        } catch _ {
            
            results = nil
            
        }
        
        if results != nil {
            
            self.items = results as! [Item]
            
        }
        
        self.tableView.reloadData()
        
    }
    
    // MARK: - Display the number of rows by the number of Items in CoreData:
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let item = self.items[indexPath.row]
        
        // MARK: - Check to see if the Item is marked Completed. If not, return Title, if so, return Title and add Checkmark:
        
        if item.completed == false {
            
            cell.textLabel!.text = item.title
            return cell
            
        } else {
    
            cell.textLabel!.text = item.title
            cell.accessoryType = .Checkmark
            return cell
        }
        
    }
    
    // MARK: = Add swipe to Delete functionality:
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
        switch editingStyle {
        
        case .Delete:
            // remove the deleted item from the model
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let context: NSManagedObjectContext = appDel.managedObjectContext
            
            context.deleteObject(self.items[indexPath.row] as NSManagedObject)
            
            self.items.removeAtIndex(indexPath.row)
            
            do {
                
                try context.save()
                
            } catch _ {
                
                // Do nothing
                
            }
            
            // MARK: - Remove the deleted item from the tableView
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        default:
            return
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // MARK: - Adds a checkmark, but when restarted the checkmark isn't there. Write the checkmark to CoreData
        
        // Add selected Index to CoreData
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
        // If Checkmark = nil, then add checkmark, otherwise cell.assessoryType = .None
        
    }
    
    // MARK: - Alert Functionality:
    
    func alertPopUp() {
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            
            UIAlertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) {
            
            UIAlertAction in
            self.saveNewItem()
            
        }
        
        alert.addTextFieldWithConfigurationHandler(configureTextField)
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    /*
    func checkComplete() -> Bool {
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let request = NSFetchRequest(entityName: "Item")
        
        var results : [AnyObject]?
        
        do {
            
            results = try context.executeFetchRequest(request)
            
        } catch _ {
            
            results = nil
            
        }
        
        if results != nil {
            
            self.items = results as! [Item]
            
            // how to preset the checkmark here?
            
            return true
            
        }
        
        return false
    
    } */

}

