//
//  Item.swift
//  Todoey
//
//  Created by Rahul Padmakumar on 01/04/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @Persisted var title: String
    @Persisted var isChecked: Bool
    @Persisted var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
