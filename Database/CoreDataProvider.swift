//
//  CoreDataProvider.swift
//  Database
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import CoreData
import PromiseKit

class CoreDataProvider {
    private static var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let lastUrl = urls.last else {
            fatalError("Failed to retrieve applicationDocumentsDirectory")
        }
        return urls[urls.count-1]
    }()

    private static var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: CoreDataProvider.self)
        guard let url = bundle.url(forResource: "DataModel", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to setup Core Data stack")
        }
        return model
    }()

    private static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent("TvMaze.sqlite")
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: NSNumber(value: true),
            NSInferMappingModelAutomaticallyOption: NSNumber(value: true)
        ]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            fatalError("Failed to start persistent store coordinator \(error.localizedDescription)")
        }

        return coordinator
    }()

    static var context: NSManagedObjectContext = {
        let coordinator = persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()


    static func save() -> Promise<Void> {
        Promise { seal in
            if context.hasChanges {
                context.perform {
                    try? context.save()
                    seal.fulfill(())
                }
            } else {
                seal.fulfill(())
            }
        }
    }
}
