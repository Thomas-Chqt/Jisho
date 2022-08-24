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
        let fetchRequest = NSFetchRequest<Liste>(entityName: "Liste")
        fetchRequest.includesSubentities = false
        
        return fetchRequest
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSManagedObjectID> {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>(entityName: "Liste")
        fetchRequest.includesSubentities = false
        fetchRequest.resultType = .managedObjectIDResultType
        
        return fetchRequest
    }
    
    
    @NSManaged private var timestampAtb: Date?
    @NSManaged private var nameAtb: String?
    
    @NSManaged private var parent: Liste?
    @NSManaged public var ordreInParentAtb: Int64
    
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
            
            for (i, value) in (newValue ?? []).enumerated() {
                value.ordre = Int64(i)
            }
            
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
            
            Task {
                try await DataController.shared.save()
            }
        }
    }

    
    var motsObjIDs: [NSManagedObjectID]? {
        get {
            return motsObjIDURIAtb?.getObjectIDs()
        }
        set {
            motsObjIDURIAtb = newValue?.map { $0.uriRepresentation() }
        }
    }
    
    var mots: [Mot]? {
        get {
            return motsObjIDs?.getObjects(on: .mainQueue)
        }
        
        set {
            self.objectWillChange.send()

            guard let newValue = newValue else {
                
                Task {
                    try await DataController.shared.save()
                }
                
                motsObjIDs = nil
                
                return
                
            }
            
            if newValue.isEmpty {
                
                Task {
                    try await DataController.shared.save()
                }
                
                motsObjIDs = nil
                
                return
                
            }
            
            do {
                motsObjIDs = try newValue.getObjectIDs(on: .mainQueue)
                timestamp = Date()
            }
            catch {
                fatalError(error.localizedDescription)
            }
            
            Task {
                try await DataController.shared.save()
            }
        }
    }
    
        
    
    public func contains(_ mot: Mot) -> Bool {
        return mots?.contains(mot) == true
    }
    
    
    
    convenience init(name:String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = name
        self.ordre = -99
        self.mots = nil
        self.souListAtb = nil
        
        timestamp = Date()
    }
    
    convenience init(jishoSaveListe: JishoSave_Liste, uuidToObjIDDict:[UUID:NSManagedObjectID], context: NSManagedObjectContext) {
        self.init(name: jishoSaveListe.name, context: context)
        
        for mot in jishoSaveListe.mots {
            self.motsObjIDs = (self.motsObjIDs ?? []) + [uuidToObjIDDict[mot]!]
        }
        for sousListe in jishoSaveListe.sousListes {
            self.sousListes = (self.sousListes ?? []) + [Liste(jishoSaveListe: sousListe, uuidToObjIDDict: uuidToObjIDDict, context: context)]
        }
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
