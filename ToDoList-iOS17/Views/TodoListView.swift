//
//  ViewController.swift
//  ToDoList-iOS17
//
//  Created by Alvin Nguyen on 2/8/24.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    // Initialized an array of Item objects
    var itemArray = [Item]()
    
    // .default is a Singleton, .userDomainMask is their homeDirectory
    // Creates our own plist at the data location point
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // Tap into "UIApplication" object, get the "shared" singleton object which is the current app as an object
    // We then tap into it's delegate which has data type UIApplicationDelegate and we downcast it as AppDelegate since they both inherit from the same superclass UIApplicationDelegate
    // Then we get access to our app delegate as an object, and can get it property persistentContainer
    // This is all to get access to the persistentContainer as shown in our AppDelegate saveContext() method
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArray.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        // Our row will now return an Item Object that contains multiple fields, so we need to tap into the title
        cell.textLabel?.text = item.title
        
        // Swift Ternary Operator, if item.done is true set to .checkmark else .none
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    // Gets the current item object thats selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Example of updating title in our database
        // itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        // Reverses the state of the .done
        // Sets the value of our .done key in our database to either 0 or 1
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Below is to remove the data from our database (from our currently selected row)
        // Have to call context.delete first, to make sure index isn't out of range when we call itemArray.remove
        /*context.delete(itemArray[indexPath.row])*/ // Note, this does nothing until we SAVE the context
        // Below just modifies the itemArray for display on our app
        // itemArray.remove(at: indexPath.row)
        
        // Calls context.save() to save our modifications to the context
        saveItems()
        
        // Animation for deselecting selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    // What happens when user clicks on the "add item" button on our UIAlert
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // We create a new item object and append the item (that includes whatever the user types in)
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
       
        }
        
        // Occurs right when we hit the "+" button
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        do {
            // Transfers from "scratchpad" to permanent memory
            try context.save()
        } catch {
            print("Error saving content \(error)")
        }
        
        // Reloads the rows and the sections of the table taking into account new data that was created
        self.tableView.reloadData()
    }
    
    func loadItems() {
        // Need to specify the type of the Fetch Request for our Item Object
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            // Save results of the fetch into itemArray
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
}

