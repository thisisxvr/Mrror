//
//  History.swift
//  Mrror
//
//  Created by Xavier Francis on 26/09/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import Foundation
import CoreData

class History: NSManagedObject {
    static var entityName: String { return "History" }
    
    @NSManaged var time: Date
    @NSManaged var user: String

    @NSManaged var entries: NSSet
}
