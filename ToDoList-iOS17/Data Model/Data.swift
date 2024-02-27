//
//  Data.swift
//  ToDoList-iOS17
//
//  Created by Alvin Nguyen on 2/26/24.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
