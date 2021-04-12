//
//  CoreDataManager.swift
//  TimeZoneTrack
//
//  Created by Anantha on 25/03/21.
//  Copyright © 2021 AK. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    let dataModelName = "TimeZone" // model name will need to be entered here
    static let shared = CoreDataManager()
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        description.url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(dataModelName + ".sqlite")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("Error saving context: \(error)")
            }
        }
    }
}
