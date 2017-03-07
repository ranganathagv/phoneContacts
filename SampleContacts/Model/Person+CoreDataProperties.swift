//
//  Person+CoreDataProperties.swift
//  SampleContacts
//
//  Created by Ranganatha Veeranagappa on 2/28/17.
//  Copyright © 2017 Ranganatha Veeranagappa. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }


}
