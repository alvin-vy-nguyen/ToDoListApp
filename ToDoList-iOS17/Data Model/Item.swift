//
//  Item.swift
//  ToDoList-iOS17
//
//  Created by Alvin Nguyen on 2/27/24.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    // Creating inverse Relationship
    // LinkingObjects simply define the inverse relationship
    // Category is just the class, we use .self to specify the type
    // Each Item will have a parentCategory of type Category that comes from property items (from Category file)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
