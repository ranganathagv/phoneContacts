//
//  ContactsInfo+CoreDataProperties.swift
//  SampleContacts
//
//  Created by Ranganatha Veeranagappa on 2/27/17.
//  Copyright © 2017 Ranganatha Veeranagappa. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ContactsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactsEntity> {
        return NSFetchRequest<ContactsEntity>(entityName: "ContactsEntity");
    }

    @NSManaged public var givenName: String?
    @NSManaged public var familyName: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var emailAddress: String?

}

