//
//  SearchTableHolderMotJMdict+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/04/24.
//
//

import Foundation
import CoreData

@objc(SearchTableHolderMotJMdict)
public class SearchTableHolderMotJMdict: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchTableHolderMotJMdict> {
        return NSFetchRequest<SearchTableHolderMotJMdict>(entityName: "SearchTableHolderMotJMdict")
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSManagedObjectID> {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>(entityName: "SearchTableHolderMotJMdict")
        fetchRequest.resultType = .managedObjectIDResultType
        fetchRequest.includesSubentities = false
        return fetchRequest
    }

    @NSManaged public var searchTableAtb: [String:Set<URL>]?
    @NSManaged public var idAtb: Int16
    
    var searchTable: [String:Set<NSManagedObjectID>] {
        
        get {
            guard let searchTableAtb = searchTableAtb else { fatalError() }
            return searchTableAtb.mapValues {
                Set($0.map {
                    DataController.shared.container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: $0)!
                })
            }
        }
        
        set {
            searchTableAtb = newValue.mapValues { Set($0.map { $0.uriRepresentation() }) }
        }
    }
    
    convenience init(id: Int, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.idAtb = Int16(id)
        self.searchTableAtb = [:]
    }
}
