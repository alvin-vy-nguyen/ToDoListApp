//
//  ViewController.swift
//  ToDoList-iOS17
//
//  Created by Alvin Nguyen on 2/8/24.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    // Results container filled with items
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    // Optional until intialized (or selected from CategoryViewController)
    var selectedCategory : Category? {
        didSet {
            // This block happens as soon as selectedCategory gets set with a value
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems?.count ?? 1
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Optional binding here to avoid making our accessory methods an optional as well
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // Swift Ternary Operator, if item.done is true set to .checkmark else .none
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        

        return cell
    }
    
    //MARK: - TableView Delegate Methods
    // Gets the current item object thats selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Check if todoItems is not nil
        if let item = todoItems?[indexPath.row] {
            do {
                // If not nil, we update, and reverse the current bool for checkmark status
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        // Animation for deselecting selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    // What happens when user clicks on the "add item" button on our UIAlert
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Checks and unwrap if selectedCategory is correct
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        // Append new item to Category list, NOTE: this is not a Results container but an Item object
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
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
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        // All items that belong to current selected category, sorted by title ascending
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

//MARK: - Search Bar methods
extension TodoListViewController: UISearchBarDelegate {
    // Triggered when user taps on the search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Don't need to call loadItems since we're doing it within our selected category
        // Filter by property "title" [cd] substituted (%@") by what's in the search bar
        // Then we sort by that property by ascending
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    // Only triggers when text changes (not on first load-up when its empty)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            // Fetches all items with our default query
            loadItems()
            
            // Runs this method on the main Queue
            DispatchQueue.main.async {
                // No longer have cursor & keyboard goes away
                searchBar.resignFirstResponder()
            }
        }
    }
}
