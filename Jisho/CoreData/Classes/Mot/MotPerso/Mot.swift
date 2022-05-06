//
//  Mot+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/07.
//
//

import Foundation
import CoreData

@objc(Mot)
public class Mot: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mot> {
        let fetchRequest = NSFetchRequest<Mot>(entityName: "Mot")
        fetchRequest.includesSubentities = false
        
        return fetchRequest
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSManagedObjectID> {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>(entityName: "Mot")
        fetchRequest.includesSubentities = false
        fetchRequest.resultType = .managedObjectIDResultType
        
        return fetchRequest
    }
    
    
    @nonobjc public class func fetchRequest(uuid:UUID) -> NSFetchRequest<Mot> {
        let fetchRequest:NSFetchRequest<Mot> = Mot.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        fetchRequest.predicate = NSPredicate(format: "uuidAtb == %@", uuid as CVarArg)
        
        return fetchRequest
    }
    
    
    @nonobjc public class func fetchRequest(uuids:[UUID]) -> NSFetchRequest<Mot> {
        let fetchRequest:NSFetchRequest<Mot> = Mot.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "uuidAtb IN %@", uuids as CVarArg)
        return fetchRequest
    }
    
    @nonobjc public class func fetchRequest(uuids:[UUID]) -> NSFetchRequest<NSManagedObjectID> {
        let fetchRequest:NSFetchRequest<NSManagedObjectID> = Mot.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "uuidAtb IN %@", uuids as CVarArg)
        return fetchRequest
    }
    
    @nonobjc public class func fetchRequest(recherche:String) -> NSFetchRequest<NSManagedObjectID> {
        
        let fetchRequest:NSFetchRequest<NSManagedObjectID> = Mot.fetchRequest()
        
        fetchRequest.includesSubentities = false
        
        let sousPredicateRechercheA = NSPredicate(format: "ANY japonaisAtb.kanjiAtb CONTAINS[cd] %@", recherche)

        let sousPredicateRechercheB = NSPredicate(format: "ANY japonaisAtb.kanaAtb CONTAINS[cd] %@", recherche)

        let sousPredicateRechercheC =
        NSPredicate(format: "SUBQUERY( sensesAtb, $sense, ANY $sense.traductionsAtb.joinedTradutionsAtb CONTAINS[cd] %@ ).@count > 0",
                    recherche)
        
        let sousPredicateRechercheD = NSPredicate(format: "ANY noSenseTradAtb.joinedTradutionsAtb CONTAINS[cd] %@", recherche)

        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [sousPredicateRechercheA,
                                                                                    sousPredicateRechercheB,
                                                                                    sousPredicateRechercheC,
                                                                                    sousPredicateRechercheD])
        
        
        return fetchRequest
    }
    
    
    //MARK: NSManaged attributes
    
    @NSManaged private var uuidAtb: UUID?
    @NSManaged private var ordreAtb: Int64
    @NSManaged private var timestampAtb: Date?

    @NSManaged private var japonaisAtb: NSSet?
    @NSManaged private var sensesAtb: NSSet?
    @NSManaged private var noSenseTradAtb: NSSet?
    
    @NSManaged private var notesAtb: String?
    
    
    //MARK: Not override in children

    var context: NSManagedObjectContext {
        guard let context = self.managedObjectContext else { fatalError() }
        return context
    }
    
    var uuid: UUID {
        get {
            return uuidAtb!
        }
        set {
            uuidAtb = newValue
        }
    }
    
    var ordre: Int64 {
        get {
            return ordreAtb
        }
        set {
            ordreAtb = newValue
        }
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
        
    
    
    //MARK: Override in children

    var japonais: [Japonais]? {
        get {
            if japonaisAtb == nil { return nil }
            if japonaisAtb!.allObjects.isEmpty { return nil }
            
            let set = japonaisAtb as! Set<Japonais>
            return set.sorted {
                $0.ordre < $1.ordre
            }
        }
        set {
            objectWillChangeSend()
            
            for japonai in newValue ?? [] {
                if !(japonais ?? []).contains(japonai) {
                    addToJaponaisAtb(japonai)
                }
            }
            for japonai in japonais ?? [] {
                if !(newValue ?? []).contains(japonai) {
                    removeFromJaponaisAtb(japonai)
                    self.context.delete(japonai)
                }
            }
            for (i, japonai) in (japonais ?? []).enumerated() {
                japonai.ordre = Int64(i)
            }
        }
    }
        
    var senses: [Sense]? {
        get{
            if sensesAtb == nil { return nil }
            if sensesAtb!.allObjects.isEmpty { return nil }
            
            let set = sensesAtb as! Set<Sense>
            return set.sorted {
                $0.ordre < $1.ordre
            }
        }
        set{
            objectWillChangeSend()

            for sense in newValue ?? [] {
                if !(senses ?? []).contains(sense) {
                    addToSensesAtb(sense)
                }
            }
            for sense in senses ?? [] {
                if !(newValue ?? []).contains(sense) {
                    removeFromSensesAtb(sense)
                    self.context.delete(sense)
                }
            }
            for (i, sense) in (senses ?? []).enumerated() {
                sense.ordre = Int64(i)
            }
        }
    }
      
    var noSenseTradsArray: [Traduction]? {
        get{
            if noSenseTradAtb == nil { return nil }
            if noSenseTradAtb!.allObjects.isEmpty { return nil }
            
            let set = noSenseTradAtb as! Set<Traduction>
            return set.sorted {
                $0.ordre < $1.ordre
            }
        }
        set{
            objectWillChangeSend()

            for trad in newValue ?? [] {
                if !(noSenseTradsArray ?? []).contains(trad) {
                    addToNoSenseTradAtb(trad)
                }
            }
            for trad in noSenseTradsArray ?? [] {
                if !(newValue ?? []).contains(trad) {
                    removeFromNoSenseTradAtb(trad)
                    self.context.delete(trad)
                }
            }
            for (i, trad) in (noSenseTradsArray ?? []).enumerated() {
                trad.ordre = Int64(i)
            }
        }
    }
        
    var notes: String? {
        get {
            return notesAtb
        }
        set {
            objectWillChangeSend()
            notesAtb = newValue
        }
    }
    
    
    
    //MARK: Functions

    func delete(save: Bool = true) {
        self.managedObjectContext?.delete(self)
        
        if save {
            Task {
                do {
                    try await DataController.shared.save()
                }
                catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
        
    func objectWillChangeSend() {
        self.objectWillChange.send()
    }
            
    func getExactMatchKeyWords() -> Set<String> {
        
        var keyWordSet: Set<String> = []

        for jap in self.japonais ?? [] {
            if let kanji = jap.kanji { keyWordSet.insert(kanji) }
            if let kana = jap.kana { keyWordSet.insert(kana) }
        }
        
        for sense in self.senses ?? [] {
            for trad in sense.traductionsArray ?? [] {
                if let traductions = trad.traductions {
                    for trad in traductions {
                        
                        let keywords = trad
                                        .replacingOccurrences(of: "(", with: "")
                                        .replacingOccurrences(of: ")", with: "")
                                        .replacingOccurrences(of: ",", with: "")
                                        .split(separator: " ")
                        
                        for keyword in keywords {
                            keyWordSet.insert(String(keyword))
                        }
                    }
                }
            }
        }
        
        for trad in self.noSenseTradsArray ?? [] {
            if let traductions = trad.traductions {
                for trad in traductions {
                    
                    let keywords = trad
                                    .replacingOccurrences(of: "(", with: "")
                                    .replacingOccurrences(of: ")", with: "")
                                    .replacingOccurrences(of: ",", with: "")
                                    .split(separator: " ")
                    
                    for keyword in keywords {
                        keyWordSet.insert(String(keyword))
                    }
                }
            }
        }
        
        
        return keyWordSet
    }
    
    
    func moveNoSenseTradToTrad(noSenseTradToMove:Traduction, senseToMoveIn:Sense) {
        // les object envoyé peuvent etres des mot jmdict donc non modifiable il faut les recup dans le modifier
        
        if let noSenseTradToMove = self.noSenseTradsArray?.first(where: { $0 == noSenseTradToMove }) {
            if let senseToMoveIn = self.senses?.first(where: {$0 == senseToMoveIn }) {
                noSenseTradToMove.ordre = (senseToMoveIn.traductionsArray?.last?.ordre ?? -1) + 1
                
                self.removeFromNoSenseTradAtb(noSenseTradToMove)
                senseToMoveIn.traductionsArray = (senseToMoveIn.traductionsArray ?? []) + [noSenseTradToMove]
            }
            else {
                fatalError()
            }
        }
        else {
            fatalError()
        }
    }
    
    
    
    //MARK: Inits

    convenience init(ordre:Int64,
                     japonais:[Japonais]? = nil,
                     senses:[Sense]? = nil,
                     noSenseTrads:[Traduction]? = nil,
                     notes:String? = nil,
                     context:NSManagedObjectContext) {
        
        self.init(context: context)

        self.uuid = UUID()
        self.ordre = ordre
        self.timestamp = Date()
        
        self.japonais = japonais
        self.senses = senses
        self.noSenseTradsArray = noSenseTrads
        self.notes = notes
    }
    
    
    static func == (lhs: Mot, rhs: Mot) -> Bool {
        
        return  lhs.japonais == rhs.japonais &&
                lhs.senses == rhs.senses &&
                lhs.noSenseTradsArray == rhs.noSenseTradsArray &&
                lhs.notes == rhs.notes
    }
    
}


// MARK: Generated accessors for japonaisAtb
extension Mot {

    @objc(addJaponaisAtbObject:)
    @NSManaged public func addToJaponaisAtb(_ value: Japonais)

    @objc(removeJaponaisAtbObject:)
    @NSManaged public func removeFromJaponaisAtb(_ value: Japonais)

    @objc(addJaponaisAtb:)
    @NSManaged public func addToJaponaisAtb(_ values: NSSet)

    @objc(removeJaponaisAtb:)
    @NSManaged public func removeFromJaponaisAtb(_ values: NSSet)

}

// MARK: Generated accessors for noSenseTradAtb
extension Mot {

    @objc(addNoSenseTradAtbObject:)
    @NSManaged public func addToNoSenseTradAtb(_ value: Traduction)

    @objc(removeNoSenseTradAtbObject:)
    @NSManaged public func removeFromNoSenseTradAtb(_ value: Traduction)

    @objc(addNoSenseTradAtb:)
    @NSManaged public func addToNoSenseTradAtb(_ values: NSSet)

    @objc(removeNoSenseTradAtb:)
    @NSManaged public func removeFromNoSenseTradAtb(_ values: NSSet)

}

// MARK: Generated accessors for sensesAtb
extension Mot {

    @objc(addSensesAtbObject:)
    @NSManaged public func addToSensesAtb(_ value: Sense)

    @objc(removeSensesAtbObject:)
    @NSManaged public func removeFromSensesAtb(_ value: Sense)

    @objc(addSensesAtb:)
    @NSManaged public func addToSensesAtb(_ values: NSSet)

    @objc(removeSensesAtb:)
    @NSManaged public func removeFromSensesAtb(_ values: NSSet)

}

// MARK: Generated accessors for listesInAtb
extension Mot {

    @objc(addListesInAtbObject:)
    @NSManaged public func addToListesInAtb(_ value: Liste)

    @objc(removeListesInAtbObject:)
    @NSManaged public func removeFromListesInAtb(_ value: Liste)

    @objc(addListesInAtb:)
    @NSManaged public func addToListesInAtb(_ values: NSSet)

    @objc(removeListesInAtb:)
    @NSManaged public func removeFromListesInAtb(_ values: NSSet)

}
