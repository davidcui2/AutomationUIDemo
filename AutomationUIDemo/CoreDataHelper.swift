//
//  CoreDataHelper.swift
//  AutomationUIDemo
//
//  Created by Zhihao Cui on 29/10/2015.
//  Copyright © 2015 zhihaocui. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    lazy var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func getCategory() -> [Category] {
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            return result as! [Category]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return []
    }
    
    func addCategory(withName name:String) -> Bool {
        let newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedObjectContext) as! Category
        newCategory.name = name
        return saveContext()
    }
    
    func changeCategory(category:Category, withName name:String) -> Bool {
        category.name = name
        return saveContext()
    }
    
    func getProcessPlan(byCategory category:Category) -> [ProcessPlan] {
        
        return category.processPlans?.allObjects as! [ProcessPlan]
    }
    
    func addProcessPlan(withName name:String, toCategory category:Category) -> Bool {
        let newProcessPlan = NSEntityDescription.insertNewObjectForEntityForName("ProcessPlan", inManagedObjectContext: managedObjectContext) as! ProcessPlan
        newProcessPlan.name = name
        newProcessPlan.category = category
        return saveContext()
    }
    
    func changeProcessPlan(processPlan:ProcessPlan, withName name:String) -> Bool {
        processPlan.name = name
        return saveContext()
    }
    
    func getProcessPlanRevision(byProcessPlan processPlan:ProcessPlan) -> [ProcessPlanRevision] {
        
        return processPlan.revisions?.allObjects as! [ProcessPlanRevision]
    }
    
    func addProcessPlanRevision(withName name:String, toProcessPlan processPlan:ProcessPlan) -> Bool {
        let newProcessPlanRevision = NSEntityDescription.insertNewObjectForEntityForName("ProcessPlanRevision", inManagedObjectContext: managedObjectContext) as! ProcessPlanRevision
        newProcessPlanRevision.name = name
        newProcessPlanRevision.processPlan = processPlan
        return saveContext()
    }
    
    func changeProcessPlanRevision(processPlanRevision:ProcessPlanRevision, withName name:String) -> Bool {
        processPlanRevision.name = name
        return saveContext()
    }
    
    func getCellProcessPlan(byCategory category:Category) -> [CellProcessPlan] {
        
        return category.cellProcessPlans?.allObjects as! [CellProcessPlan]
    }
    
    func addCellProcessPlan(withName name:String, toCategory category:Category) -> Bool {
        let newCellProcessPlan = NSEntityDescription.insertNewObjectForEntityForName("CellProcessPlan", inManagedObjectContext: managedObjectContext) as! CellProcessPlan
        newCellProcessPlan.name = name
        newCellProcessPlan.category = category
        return saveContext()
    }
    
    func changeCellProcessPlan(cellProcessPlan:CellProcessPlan, withName name:String) -> Bool {
        cellProcessPlan.name = name
        return saveContext()
    }
    
    func getCellProcessPlanRevision(byCellProcessPlan cellProcessPlan:CellProcessPlan) -> [CellProcessPlanRevision] {
        
        return cellProcessPlan.revisions?.allObjects as! [CellProcessPlanRevision]
    }
    
    func addCellProcessPlanRevision(withName name:String, toCellProcessPlan cellProcessPlan:CellProcessPlan) -> Bool {
        let newCellProcessPlanRevision = NSEntityDescription.insertNewObjectForEntityForName("CellProcessPlanRevision", inManagedObjectContext: managedObjectContext) as! CellProcessPlanRevision
        newCellProcessPlanRevision.name = name
        newCellProcessPlanRevision.cellProcessPlan = cellProcessPlan
        return saveContext()
    }
    
    func changeCellProcessPlanRevision(cellProcessPlanRevision:CellProcessPlanRevision, withName name:String) -> Bool {
        cellProcessPlanRevision.name = name
        return saveContext()
    }
    
    // Core Data
    func saveContext () -> Bool {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                return true
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                return false
            }
        } else {
            return true
        }
    }
    
    
}