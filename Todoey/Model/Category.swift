//
//  Category.swift
//  Todoey
//
//  Created by Katie McBratney on 8/18/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String?
    let items = List<Item>()
}
