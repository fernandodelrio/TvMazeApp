//
//  CoreDataSettingsProvider.swift
//  Database
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core
import CoreData
import PromiseKit

public class CoreDataSettingsProvider: SettingsProvider {
    private let context = CoreDataProvider.context

    public init() {
    }

    public func save(_ settings: Settings) -> Promise<Void> {
        Promise { seal in
            // Calling context's perform as we are in a private queue
            context.perform {
                let request = NSFetchRequest<NSManagedObject>(entityName: "SettingsEntity")
                request.resultType = .managedObjectResultType
                // We may need to insert or update, as the table
                // will always have 1 row
                if let existingEntity = (try? self.context.fetch(request))?.first {
                    existingEntity.setValue(settings.isAuthActive, forKey: "isAuthActive")
                } else {
                    let newEntiy = NSEntityDescription.insertNewObject(forEntityName: "SettingsEntity", into: self.context)
                    newEntiy.setValue(settings.isAuthActive, forKey: "isAuthActive")
                }
                seal.fulfill(())
            }
        }
    }
    
    public func retrieveSettings() -> Promise<Settings> {
        Promise { seal in
            // Calling context's perform as we are in a private queue
            context.perform {
                let request = NSFetchRequest<NSManagedObject>(entityName: "SettingsEntity")
                request.resultType = .managedObjectResultType
                let results = try? self.context.fetch(request)
                // Check if the auth is active, then returns the settings object
                // with this info
                let isAuthActive = results?
                    .compactMap { $0.value(forKey: "isAuthActive") as? Bool }
                    .first ?? false
                let settings = Settings(isAuthActive: isAuthActive)
                seal.fulfill(settings)
            }
        }
    }
}
