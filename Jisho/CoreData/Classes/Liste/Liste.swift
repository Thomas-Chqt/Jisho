//
//  Liste+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/25.
//
//

import Foundation
import CoreData

@objc(Liste)
public class Liste: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Liste> {
        return NSFetchRequest<Liste>(entityName: "Liste")
    }

    @nonobjc public class func fetchRequestMainListe() -> NSFetchRequest<Liste> {
        let fetchRequest:NSFetchRequest<Liste> = Liste.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestampAtb", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "parent == nil")
        
        return fetchRequest
    }
    
    
    @NSManaged public var timestampAtb: Date?
    @NSManaged public var nameAtb: String?
    
    @NSManaged public var parent: Liste?
    @NSManaged public var ordreInParentAtb: Int64
    
    @NSManaged public var motsObjIDURIAtb: [URL]?
    
    @NSManaged public var souListAtb: NSSet?
    
    
    
    var timestamp: Date {
        get {
            if let timestp = timestampAtb {
                return timestp
            }
            else { fatalError("No timestamp") }
        }
        set {
            timestampAtb = newValue
        }
    }
    
    var ordre:Int64 {
        get{
            return ordreInParentAtb
        }
        set {
            ordreInParentAtb = newValue
        }
    }
    
    var name: String? {
        get {
            return self.nameAtb
        }
        
        set {
            self.nameAtb = newValue
        }
        
    }
    
    
    var motsObjIDs: [NSManagedObjectID]? {
        get {
            guard let objectIDsURIRepresented = motsObjIDURIAtb else { return nil }
            
            return objectIDsURIRepresented.map {
                DataController.shared.container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: $0)!
            }
        }
        set {
            guard let newValue = newValue else { motsObjIDURIAtb = nil ; return }
                        
            motsObjIDURIAtb = newValue.map {
                $0.uriRepresentation()
            }
        }
    }
    
    var mots: [Mot]? {
        get {
            return motsObjIDs?.map {
                DataController.shared.mainQueueManagedObjectContext.object(with: $0) as! Mot
            }
        }
        
        set {
            guard let newValue = newValue else { motsObjIDs = nil ; return }
            if newValue.isEmpty { motsObjIDs = nil ; return }
            
            do {
                try DataController.shared.mainQueueManagedObjectContext.obtainPermanentIDs(for: newValue)
                motsObjIDs = newValue.map { $0.objectID }
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    var sousListes:[Liste]? {
        get {
            if souListAtb == nil { return nil }
            if souListAtb!.allObjects.isEmpty { return nil }
            
            let set = souListAtb as! Set<Liste>
            return set.sorted
            {
                $0.ordre < $1.ordre
            }
        }
    }
    
    
    
    public func contains(_ mot: Mot) -> Bool {
        
        guard let mots = mots else { return false }

        return mots.contains(mot)
    }
    
    
    public func addMot(_ newMot: Mot) {
        if contains(newMot) { return }
                
        if mots == nil
        {
            mots = [newMot]
        }
        else {
            mots!.append(newMot)
        }
        
        timestamp = Date()
        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    public func removeMot(_ mot: Mot) {
        
        if !contains(mot) { return }
        
        mots!.remove(at: mots!.firstIndex(of: mot)!)
        
        timestamp = Date()
        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    
    public func removeMot(at index: Int) {
        if mots == nil { fatalError() }
        
        mots!.remove(at: index)
        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    
    
    func createSousListe(name:String, context:NSManagedObjectContext) -> Liste {
        
        let newOrdre = (sousListes?.last?.ordre ?? -1) + 1
        
        let newListe = Liste(ordre: newOrdre, name: name, context: context)
        
        self.addToSouListAtb(newListe)
        
        self.timestamp = Date()
        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
        
        return newListe
    }
    
    func getOrCreateSousListe(name:String, context:NSManagedObjectContext) -> Liste {
        
        guard let sousListes = self.sousListes else { return createSousListe(name: name, context: context) }
        
        if let findedListe = sousListes.first(where: { $0.name == name }) {
            return findedListe
        }
        else {
            return createSousListe(name: name, context: context)
        }
    }
    
    func deleteSousListe(liste: Liste) {
        removeFromSouListAtb(liste)
        self.managedObjectContext!.delete(liste)
        
        if sousListes != nil {
            for (i, sousListe) in sousListes!.enumerated() {
                sousListe.ordre = Int64(i)
            }
        }
        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func moveMot(from source: IndexSet, to destination: Int) {
        self.mots?.move(fromOffsets: source, toOffset: destination)
        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    
    
    convenience init(ordre:Int64 = 0, name:String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = name
        self.ordre = ordre
        self.mots = nil
        self.souListAtb = nil
        
        timestamp = Date()
    }
    
}

// MARK: Generated accessors for souListAtb
extension Liste {

    @objc(addSouListAtbObject:)
    @NSManaged public func addToSouListAtb(_ value: Liste)

    @objc(removeSouListAtbObject:)
    @NSManaged public func removeFromSouListAtb(_ value: Liste)

    @objc(addSouListAtb:)
    @NSManaged public func addToSouListAtb(_ values: NSSet)

    @objc(removeSouListAtb:)
    @NSManaged public func removeFromSouListAtb(_ values: NSSet)

}

// MARK: Generated accessors for motsAtb
extension Liste {

    @objc(addMotsAtbObject:)
    @NSManaged public func addToMotsAtb(_ value: Mot)

    @objc(removeMotsAtbObject:)
    @NSManaged public func removeFromMotsAtb(_ value: Mot)

    @objc(addMotsAtb:)
    @NSManaged public func addToMotsAtb(_ values: NSSet)

    @objc(removeMotsAtb:)
    @NSManaged public func removeFromMotsAtb(_ values: NSSet)

}
