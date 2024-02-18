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
    
    // .default is a Singleton, .userDomainMask is their homeDirectory
    // Creates our own plist at the data location point
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new item object of type Item from Item class
//        let newItem = Item()
//        newItem.title = "To DO Monday"
//        itemArray.append(newItem)
//        
//        let newItem1 = Item()
//        newItem1.title = "Starting Tuesday"
//        itemArray.append(newItem1)
//        
//        let newItem2 = Item()
//        newItem2.title = "Finishing Wednesday"
//        itemArray.append(newItem2)
        
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Gets the current item object thats selected
        // Reverses the state of the .done
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
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
        // Encodes the data to write to a plist
        let encoder = PropertyListEncoder()
        
        // .encode and .write can throw, so we need to enclose them in a do/catch with a try
        do {
            let data = try encoder.encode(itemArray)
            // Write data to data file path (creates a .plist upon writing)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        // Reloads the rows and the sections of the table taking into account new data that was created
        self.tableView.reloadData()
    }
    
    // Function that implements decoding
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding item array, \(error)")
            }
        }
    }
}

