//
//  Category.swift
//  Todoey
//
//  Created by Rahul Padmakumar on 01/04/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @Persisted var name: String
    @Persisted var color: String
    @Persisted var items: List<Item> = List<Item>()
}
