//
//  CoreDataFavoriteProvider.swift
//  Database
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import CoreData
import PromiseKit

public class CoreDataFavoriteProvider: FavoriteProvider {
    let context = CoreDataProvider.context
    let save = CoreDataProvider.save
    lazy var showProvider = Dependency.resolve(ShowProvider.self)

    public init() {
    }

    public func save(_ favorite: Favorite) -> Promise<Void> {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "FavoriteEntity", into: context)
        entity.setValue(Int32(favorite.show.id), forKey: "showId")
        return save()
    }

    public func delete(_ favorite: Favorite) -> Promise<Void> {
        Promise { seal in
            context.perform {
                let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteEntity")
                request.resultType = .managedObjectResultType
                let showId = favorite.show.id as CVarArg
                request.predicate = NSPredicate(format: "showId == %d", showId)
                if let entity = try? self.context.fetch(request).first {
                    self.context.delete(entity)
                }
                seal.fulfill(())
            }
        }
    }

    public func retrieveFavorites() -> Promise<[Favorite]> {
        Promise { seal in
            context.perform {
                let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteEntity")
                request.resultType = .managedObjectResultType
                let results = try? self.context.fetch(request)
                let showIds = results?.compactMap { $0.value(forKey: "showId") as? Int32 } ?? []
                let shows = showIds.map { self.showProvider.retrieveShow(id: Int($0)) }
                when(fulfilled: shows)
                    .map { $0.map { Favorite(show: $0) } }
                    .done { favorites in
                        seal.fulfill(favorites)
                    }.cauterize()
            }
        }
    }
}
