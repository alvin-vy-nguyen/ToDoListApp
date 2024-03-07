//
//  SwipeTableViewController.swift
//  ToDoList-iOS17
//
//  Created by Alvin Nguyen on 3/6/24.
//

import UIKit

class SwipeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Requires any screen that needs their cell tableview, to have a matching identifier of Cell
        // Creates a new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {return}
        
        print("Delete Cell")
        
        updateModel(at: indexPath)
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update our data model in their respective Controllers with override
    }

}
