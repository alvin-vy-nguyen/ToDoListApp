//
//  ViewController.swift
//  ToDoList-iOS17
//
//  Created by Alvin Nguyen on 2/8/24.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    // Initialized an array of Item objects
    var itemArray = [Item]()
    
    // Establish user defaults
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        //"To DO Monday", "Starting Tuesday", "Finishing Wednesday"
        // Create a new item object of type Item from Item class
        let newItem = Item()
        newItem.title = "To DO Monday"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "Starting Tuesday"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Finishing Wednesday"
        itemArray.append(newItem2)
        
        // When app loads up, we look into our user defaults and pull whatever is there from previous session
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
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
        cell.accessoryType = item.done == true ? .checkmark : .none // Does below more elegant
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Gets the current item object thats selected
        // Reverses the state of the .done
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // Better way of writing than below
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.reloadData()
        
        // Animation for deselecting selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What happens when user clicks on the "add item" button on our UIAlert
            // We create a new item object and append the item (that includes whatever the user types in)
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // Save user defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // Reloads the rows and the sections of the table taking into account new data that was created
            self.tableView.reloadData()
        }
        
        // Occurs right when we hit the "+" button
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

