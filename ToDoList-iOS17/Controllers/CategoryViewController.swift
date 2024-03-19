//
//  CategoryViewController.swift
//  ToDoList-iOS17
//
//  Created by Alvin Nguyen on 2/20/24.
//

import UIKit
import RealmSwift
import Chameleon
import ChameleonSwift

class CategoryViewController: SwipeTableViewController {
    
    // Valid way of declaring/creating a new Realm according to documentation
    let realm = try! Realm()
    
    // Results are auto-updating container types (lists, arrays, etc)
    // Also don't need to append since it auto-updates
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        // Removes small white line between each cell
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar.scrollEdgeAppearance else {fatalError("Navigation controller does not exist.")}
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    //MARK: - TableView Datasouce Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If not nil return categories, if nil return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Taps into the cell in our superView class (SwipeTableViewController)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let categories = categories?[indexPath.row]  {
            // We modify the cell even more additionally outside of the super class
            cell.textLabel?.text = categories.name
            
            guard let categoryColor = UIColor(hexString: categories.color) else {fatalError()}
            
            // Initializes the hex value we got using the Chameleon method at creation of category
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // Category from our Category data model
            let newCategory = Category()
            newCategory.name = textField.text!
            // Chameleon Method, .hexValue gets the color as a string
            newCategory.color = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        
        // Occurs right when we hit the "+" button
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Downcast to match the destination, navigates to ToDoListViewController
        let destinationVC = segue.destination as! TodoListViewController
        
        // Identifies current row that is selected
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving content \(error)")
        }
        
        // Reloads the rows and the sections of the table taking into account new data that was created
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        // Returns a results object that contains categories
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let selecteditem = categories?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(selecteditem)
                }
            } catch {
                print("error reversing condition \(error.localizedDescription)")
            }
            tableView.reloadData()
        }
    }
}
