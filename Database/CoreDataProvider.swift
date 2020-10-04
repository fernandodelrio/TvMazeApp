//
//  CoreDataProvider.swift
//  Database
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import CoreData
import PromiseKit

public class CoreDataProvider {
    // Setup core data stack from scratch as we need to support iOS 9
    private static var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let lastUrl = urls.last else {
            fatalError("Failed to retrieve applicationDocumentsDirectory")
        }
        return urls[urls.count - 1]
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
        // Using private queue to improve the performance
        // in the main thread
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    public init() {
        // Saving the context only when necessary
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc private func save() {
        Self.context.perform {
            if Self.context.hasChanges {
                try? Self.context.save()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
