//
//  Category.swift
//  ToDoList-iOS17
//
//  Created by Alvin Nguyen on 2/27/24.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    // Creating forward relationship
    // List is the container type in Realm used to fine to-many relationships, like arrays
    // Each Category has a list of items
    let items = List<Item>()
}
