//
//  Category.swift
//  Mylist
//
//  Created by Krzysztof Synowiec on 23/05/2018.
//  Copyright © 2018 Krzysztof Synowiec. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
