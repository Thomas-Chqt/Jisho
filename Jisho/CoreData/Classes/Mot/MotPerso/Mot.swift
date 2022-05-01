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
    
    

    @NSManaged private var uuidAtb: UUID?
    @NSManaged public var ordreAtb: Int64
    @NSManaged public var timestampAtb: Date?

    @NSManaged private var japonaisAtb: NSSet?
    @NSManaged private var sensesAtb: NSSet?
    @NSManaged private var noSenseTradAtb: NSSet?
    
    @NSManaged private var notesAtb: String?
    
    
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
        
    
    var japonais: [Japonais]? {
        get {
            if japonaisAtb == nil { return nil }
            if japonaisAtb!.allObjects.isEmpty { return nil }
            
            let set = japonaisAtb as! Set<Japonais>
            return set.sorted
            {
                $0.ordre < $1.ordre
            }
        }
        set {
            for japonai in japonais ?? [] {
                removeFromJaponaisAtb(japonai)
                self.managedObjectContext!.delete(japonai)
            }
                        
            for japonai in newValue ?? [] {
                addToJaponaisAtb(japonai)
            }
        }
    }
        
    var senses: [Sense]? {
        get{
            if sensesAtb == nil { return nil }
            if sensesAtb!.allObjects.isEmpty { return nil }
            
            let set = sensesAtb as! Set<Sense>
            return set.sorted
            {
                $0.ordre < $1.ordre
            }
        }
        set{
            for sense in senses ?? [] {
                removeFromSensesAtb(sense)
                self.managedObjectContext!.delete(sense)
            }
            for sense in newValue ?? [] {
                addToSensesAtb(sense)
            }
        }
    }
      
    var noSenseTradsArray: [Traduction]? {
        get{
            if noSenseTradAtb == nil { return nil }
            if noSenseTradAtb!.allObjects.isEmpty { return nil }
            
            let set = noSenseTradAtb as! Set<Traduction>
            let array = Array(set)
            return array//.sorted(savedLanguesPref)
        }
        set{
            for trad in noSenseTradsArray ?? [] {
                removeFromNoSenseTradAtb(trad)
                self.managedObjectContext!.delete(trad)
            }
            for trad in newValue ?? [] {
                addToNoSenseTradAtb(trad)
            }
        }
    }
        
    var notes: String? {
        get {
            return notesAtb
        }
        set {
            notesAtb = newValue
        }
    }
    
    
    
    func modify(_ motStruc:MotStruct) {
        objectWillChange.send()
        
        var newJaponais:[Japonais]? = nil
        var newSenses:[Sense]? = nil
        var newNoSenseTradsArray:[Traduction]? = nil

        
        for (i, japonai) in (motStruc.japonais).enumerated() {
            
            if newJaponais == nil { newJaponais = [] }
            
            newJaponais!.append(Japonais(ordre: Int64(i),
                                     kanji: japonai.kanji != "" ? japonai.kanji : nil,
                                     kana: japonai.kana != "" ? japonai.kana : nil,
                                     context: self.managedObjectContext!))
        }

        for (i, sense) in (motStruc.senses).enumerated() {
            
            var newTraductions:[Traduction]? = nil
            for (i, trad) in (sense.traductionsArray).enumerated() {
                
                if newTraductions == nil { newTraductions = [] }
                
                newTraductions!.append(Traduction(ordre: Int64(i),
                                                  langue: trad.langue,
                                                  traductions: trad.traductions != "" ? trad.traductions.components(separatedBy: ", ") : nil,
                                                  context: self.managedObjectContext!))
            }
            
            if newSenses == nil { newSenses = [] }
            
            newSenses!.append(Sense(ordre: Int64(i),
                                    metaDatas: sense.metaDatas.isEmpty ? nil : sense.metaDatas,
                                    traductions: newTraductions,
                                    context: self.managedObjectContext!))
        }
        
        for (i, trad) in (motStruc.noLangueTrads).enumerated() {
            
            if newNoSenseTradsArray == nil { newNoSenseTradsArray = [] }
            
            newNoSenseTradsArray!.append(Traduction(ordre: Int64(i),
                                                    langue: trad.langue,
                                                    traductions: trad.traductions != "" ? trad.traductions.components(separatedBy: ", ") : nil,
                                                    context: self.managedObjectContext!))
        }

        
        self.japonais = newJaponais
        self.senses = newSenses
        self.noSenseTradsArray = newNoSenseTradsArray
        
        if motStruc.notes != "" { self.notes = motStruc.notes } else { self.notes = nil }
        
        self.timestamp = Date()
        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func delete() {
        self.managedObjectContext?.delete(self)
        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func reset() {
        fatalError("Cannot reset mot perso")
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
    
    
    convenience init(odre:Int64,
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
