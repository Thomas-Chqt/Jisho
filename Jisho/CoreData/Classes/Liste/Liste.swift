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
    
    
    @NSManaged private var timestampAtb: Date?
    @NSManaged private var nameAtb: String?
    
    @NSManaged private var parent: Liste?
    @NSManaged private var ordreInParentAtb: Int64
    
    @NSManaged private var motsObjIDURIAtb: [URL]?

    
    @NSManaged private var souListAtb: NSSet?
    
    
    
    var context: NSManagedObjectContext {
        guard let context = self.managedObjectContext else { fatalError() }
        return context
    }

    
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
    
    
    var sousListes: [Liste]? {
        get {
            if souListAtb == nil { return nil }
            if souListAtb!.allObjects.isEmpty { return nil }
            
            let set = souListAtb as! Set<Liste>
            return set.sorted { $0.ordre < $1.ordre }
        }
        set {
            self.objectWillChange.send()
            
            for liste in newValue ?? [] {
                if !(sousListes ?? []).contains(liste) {
                    addToSouListAtb(liste)
                    timestamp = Date()
                }
            }
            for liste in sousListes ?? [] {
                if !(newValue ?? []).contains(liste) {
                    removeFromSouListAtb(liste)
                    self.context.delete(liste)
                    timestamp = Date()
                }
            }
            for (i, liste) in (sousListes ?? []).enumerated() {
                liste.ordre = Int64(i)
            }
        }
    }

    private var motsObjIDs: [NSManagedObjectID]? {
        get {
//            guard let objectIDsURIRepresented = motsObjIDURIAtb else { return nil }
            return motsObjIDURIAtb?.getObjectIDs()
        }
        set {
//            guard let newValue = newValue else { motsObjIDURIAtb = nil ; return }
            motsObjIDURIAtb = newValue?.map { $0.uriRepresentation() }
        }
    }
    
    var mots: [Mot]? {
        get {
            return motsObjIDs?.getObjects(on: .mainQueue)
        }
        
        set {
            guard let newValue = newValue else { motsObjIDs = nil ; return }
            if newValue.isEmpty { motsObjIDs = nil ; return }
            
            do {
                motsObjIDs = try newValue.getObjectIDs(on: .mainQueue)
                timestamp = Date()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    
    
    
    public func contains(_ mot: Mot) -> Bool {
//        guard let mots = mots else { return false }
        return mots?.contains(mot) == true
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
