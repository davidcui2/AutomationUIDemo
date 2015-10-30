//
//  CellProcessPlanRevision+CoreDataProperties.swift
//  AutomationUIDemo
//
//  Created by Zhihao Cui on 29/10/2015.
//  Copyright © 2015 zhihaocui. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CellProcessPlanRevision {

    @NSManaged var name: String?
    @NSManaged var comment: String?
    @NSManaged var cellEntities: NSSet?
    @NSManaged var cellProcessPlan: CellProcessPlan?

}
