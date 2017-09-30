//
//  User.swift
//  Mrror
//
//  Created by Xavier Francis on 26/09/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    static var entityName: String { return "User" }
    
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var occupation: String
    @NSManaged var gender: String
    @NSManaged var ageGroup: String
    @NSManaged var registrationTime: Date

    @NSManaged var logins: NSSet
}
