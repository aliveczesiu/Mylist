//
//  Item.swift
//  Mylist
//
//  Created by Krzysztof Synowiec on 23/05/2018.
//  Copyright © 2018 Krzysztof Synowiec. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
