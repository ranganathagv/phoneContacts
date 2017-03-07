//
//  Employee+CoreDataProperties.swift
//  SampleContacts
//
//  Created by Ranganatha Veeranagappa on 2/28/17.
//  Copyright © 2017 Ranganatha Veeranagappa. All rights reserved.
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee");
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var department: String?

}
