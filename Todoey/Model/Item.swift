//
//  Item.swift
//  Todoey
//
//  Created by Katie McBratney on 8/18/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var textColor: String?
    
//    let date = Date()
//    let calendar = Calendar.current
//    let hour = calendar.component(.hour, from: date)
//    let minutes = calendar.component(.minute, from: date)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
