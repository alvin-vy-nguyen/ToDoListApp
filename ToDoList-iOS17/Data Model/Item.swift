//
//  Item.swift
//  ToDoList-iOS17
//
//  Created by Alvin Nguyen on 2/16/24.
//

import Foundation

// Codable is both the encodable and decodable protocols
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
