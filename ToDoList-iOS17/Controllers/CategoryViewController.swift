//
//  CategoryViewController.swift
//  ToDoList-iOS17
//
//  Created by Alvin Nguyen on 2/20/24.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // Valid way of declaring/creating a new Realm according to documentation
    let realm = try! Realm()
    
    // Results are auto-updating container types (lists, arrays, etc)
    // Also don't need to append since it auto-updates
    var categories: Results<Category>?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - TableView Datasouce Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // If not nil return categories, if nil return 1
            return categories?.count ?? 1
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
        
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
    
    //MARK: - TableView Delegate Methods
    // What should happen when we click on one of the cells
}
