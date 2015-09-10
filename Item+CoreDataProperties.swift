//
//  Item+CoreDataProperties.swift
//  ToDoList
//
//  Created by Scott Barlow on 8/23/15.
//  Copyright © 2015 Scott Barlow. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var title: String?
    @NSManaged var completed: NSNumber?

}
