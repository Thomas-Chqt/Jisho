//
//  MotJMdict+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/07.
//
//

import Foundation
import CoreData

@objc(MotJMdict)
public class MotJMdict: Mot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotJMdict> {
        let fetchRequest = NSFetchRequest<MotJMdict>(entityName: "MotJMdict")
        fetchRequest.includesSubentities = false
        return fetchRequest
    }
    
    @nonobjc public override class func fetchRequest() -> NSFetchRequest<NSManagedObjectID> {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>(entityName: "MotJMdict")
        fetchRequest.resultType = .managedObjectIDResultType
        fetchRequest.includesSubentities = false
        return fetchRequest
    }
    
    @nonobjc public class func fetchRequest(jmDictID:[Int64]) -> NSFetchRequest<MotJMdict> {
        let fetchRequest:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "jmDictIDAtb IN %@", jmDictID)

        return fetchRequest
    }
    
    @nonobjc public class func fetchRequest(jmDictID:Int64) -> NSFetchRequest<MotJMdict> {
        let fetchRequest:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "jmDictIDAtb == %i", jmDictID)
        
        return fetchRequest
    }
    
    @nonobjc public class func fetchRequest(uuid:UUID) -> NSFetchRequest<MotJMdict> {
        let fetchRequest:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "uuidAtb == %@", uuid as CVarArg)
        return fetchRequest
    }

    @nonobjc public class func fetchRequest(uuids:[UUID]) -> NSFetchRequest<MotJMdict> {
        let fetchRequest:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "uuidAtb IN %@", uuids as CVarArg)
        return fetchRequest
    }
    
    @nonobjc public override class func fetchRequest(uuids:[UUID]) -> NSFetchRequest<NSManagedObjectID> {
        let fetchRequest:NSFetchRequest<NSManagedObjectID> = MotJMdict.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "uuidAtb IN %@", uuids as CVarArg)
        return fetchRequest
    }
    
      
    
//    @nonobjc public class func fetchRequest(recherche:String,
//                                            allModifiedMotUUIDs:[UUID],
//                                            searchedModifiedMotUUIDs:[UUID]) -> NSFetchRequest<NSManagedObjectID> {
    @nonobjc public class func fetchRequest(recherche:String,
                                            allModifiedMotObjIDs:[NSManagedObjectID],
                                            searchedModifiedMotObjIDs:[NSManagedObjectID]) -> NSFetchRequest<NSManagedObjectID> {
        
        let fetchRequest:NSFetchRequest<NSManagedObjectID> = MotJMdict.fetchRequest()
        
//        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(key: "timestampAtb", ascending: false),
//            NSSortDescriptor(key: "ordreAtb", ascending: true)
//        ]
        

        let sousPredicateRechercheA = NSPredicate(format: "ANY japonaisJMdictAtb.kanjiAtb CONTAINS[cd] %@", recherche)
        
        let sousPredicateRechercheB = NSPredicate(format: "ANY japonaisJMdictAtb.kanaAtb CONTAINS[cd] %@", recherche)

        let sousPredicateRechercheC =
        NSPredicate(format: "SUBQUERY( sensesJMdictAtb, $sense, ANY $sense.traductionsJMdictAtb.joinedTradutionsAtb CONTAINS[cd] %@ ).@count > 0",
                    recherche)
        
        let sousPredicateRechercheD = NSPredicate(format: "ANY noSenseTradJMdictAtb.joinedTradutionsAtb CONTAINS[cd] %@", recherche)

        
        let predicateRecherche = NSCompoundPredicate(orPredicateWithSubpredicates: [sousPredicateRechercheA,
                                                                                    sousPredicateRechercheB,
                                                                                    sousPredicateRechercheC,
                                                                                    sousPredicateRechercheD
                                                                                   ])

        let predicateNotModified = NSPredicate(format: "NOT (self IN %@)", allModifiedMotObjIDs)

        
        let predicate1 = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateRecherche, predicateNotModified])
        
        let predicate2 = NSPredicate(format: "self IN %@", searchedModifiedMotObjIDs)
        
        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2])
        
        return fetchRequest
    }
    
    
    
    @NSManaged private var jmDictIDAtb: Int64
    
    @NSManaged private var japonaisJMdictAtb: NSSet?
    @NSManaged private var noSenseTradJMdictAtb: NSSet?
    @NSManaged private var sensesJMdictAtb: NSSet?
    
    
    var jmDictID: Int64 {
        get {
            return jmDictIDAtb
        }
        set {
            jmDictIDAtb = newValue
        }
    }
    
  
    
    var japonaisReel: [JaponaisJMdict]? {
        get {
            if japonaisJMdictAtb == nil { return nil }
            if japonaisJMdictAtb!.allObjects.isEmpty { return nil }
            
            let set = japonaisJMdictAtb as! Set<JaponaisJMdict>
            return set.sorted
            {
                $0.ordre < $1.ordre
            }
        }
        set {
            for japonai in japonaisReel ?? [] {
                removeFromJaponaisJMdictAtb(japonai)
                self.managedObjectContext!.delete(japonai)
            }
            for japonai in newValue ?? [] {
                addToJaponaisJMdictAtb(japonai)
            }
        }
    }
    
    var sensesReel: [SenseJMdict]? {
        get{
            if sensesJMdictAtb == nil { return nil }
            if sensesJMdictAtb!.allObjects.isEmpty { return nil }
            
            let set = sensesJMdictAtb as! Set<SenseJMdict>
            return set.sorted
            {
                $0.ordre < $1.ordre
            }
        }
        set{
            for sense in sensesReel ?? [] {
                removeFromSensesJMdictAtb(sense)
                self.managedObjectContext!.delete(sense)
            }
            for sense in newValue ?? [] {
                addToSensesJMdictAtb(sense)
            }
        }
    }
        
    var noSenseTradsArrayReel: [TraductionJMdict]? {
        get{
            if noSenseTradJMdictAtb == nil { return nil }
            if noSenseTradJMdictAtb!.allObjects.isEmpty { return nil }
            
            let set = noSenseTradJMdictAtb as! Set<TraductionJMdict>
            let array = Array(set)
            return array//.sorted(savedLanguesPref)
        }
        set{
            for trad in noSenseTradsArrayReel ?? [] {
                removeFromNoSenseTradJMdictAtb(trad)
                self.managedObjectContext!.delete(trad)
            }
            for trad in newValue ?? [] {
                addToNoSenseTradJMdictAtb(trad)
            }
        }
    }

    
    var notesReel: String? {
        get {
            return super.notes
        }
        set {
            super.notes = newValue
        }
    }
    
    
    
    override var japonais: [Japonais]? {
        get{
            do {
                if let modifier = try getModifier() {
                    return modifier.japonais
                }
                else {
                    return self.japonaisReel
                }
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
        
        set {
            fatalError("Cannot modify directly")
        }
    }
    
    override var senses: [Sense]? {
        get{
            do {
                if let modifier = try getModifier() {
                    return modifier.senses
                }
                else {
                    return self.sensesReel
                }
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
        
        set {
            fatalError("Cannot modify directly")
        }
    }
        
    override var noSenseTradsArray: [Traduction]?{
        get{
            do {
                if let modifier = try getModifier() {
                    return modifier.noSenseTradsArray
                }
                else {
                    return self.noSenseTradsArrayReel
                }
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
        
        set {
            fatalError("Cannot modify directly")
        }
    }
    
    
    override var notes: String? {
        get{
            do {
                if let modifier = try getModifier() {
                    return modifier.notes
                }
                else {
                    return self.notesReel
                }
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
        
        set {
            fatalError("Cannot modify directly")
        }
    }
    

    
    func getModifier() throws -> MotModifier? {
        /*
        if let cachedVersion = cacheMotModifier.object(forKey: self.uuid as NSUUID) {
            
            let findedObj = self.context.object(with: cachedVersion)
            if !findedObj.isFault {
                return (findedObj as! MotModifier)
            }
        }
         */
        
        
//        let fetchRequest = MotModifier.fetchRequest(modifiedMotUUID: self.uuid)
        let fetchRequest = MotModifier.fetchRequest(modifiedMotObjID: self.objectID)
        
        
        var motModifiers:[MotModifier] = try context.fetch(fetchRequest)
        motModifiers.sort(by: {$0.timestamp > $1.timestamp})
        
        if motModifiers.count > 0
        {
            let mostRecentModifier = motModifiers.removeFirst()
            
            for mot in motModifiers {
                self.context.delete(mot)
            }
            
//            cacheMotModifier.setObject(mostRecentModifier.objectID, forKey: self.uuid as NSUUID)
            return mostRecentModifier            
        }
        
        else { return nil } // pas de modifieur
          
    }
    
    func getOrCreateModifier() throws -> MotModifier {
        
        if let modifier = try getModifier() {
            return modifier
        }
        else {
            self.timestamp = Date()
            return MotModifier(self)
        }
    }
    
    
    override func modify(_ motStruc:MotStruct) {
        objectWillChange.send()
        
        do {
            let modifier = try getOrCreateModifier()
            modifier.modify(motStruc)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    override func delete() {
        fatalError("Cannot delete JMdict mot")
    }
    
    override func reset() {
        objectWillChange.send()
        
        do {
            if let modifier = try getModifier() {
                modifier.delete()
                cacheMotModifier.removeObject(forKey: self.uuid as NSUUID)
            }
            else {
                fatalError("Unable to find the modifier, should check before try to reset")
            }
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
            
    
    convenience init(odre:Int64,
                     jmDictID:Int64,
                     uuid:UUID,
                     japonais:[JaponaisJMdict]? = nil,
                     senses:[SenseJMdict]? = nil,
                     noSenseTrads:[TraductionJMdict]? = nil,
                     notes:String? = nil,
                     context:NSManagedObjectContext) {
        self.init(context: context)

        self.uuid = uuid
        self.ordre = ordre
        self.timestamp = Date(timeIntervalSince1970: TimeInterval(0))
        
        self.jmDictID = jmDictID
        
        self.japonaisReel = japonais
        self.sensesReel = senses
        self.noSenseTradsArrayReel = noSenseTrads
        self.notesReel = notes
    }
    
    
    convenience init(ordre: Int64, strct:MotImporter, context:NSManagedObjectContext) {
        var japonais:[JaponaisJMdict] = []
        var senses:[SenseJMdict] = []
        var noSenseTrads:[TraductionJMdict] = []
        
        for (i,jap) in strct.japonais.enumerated() {
            japonais.append(JaponaisJMdict(ordre: Int64(i),
                                           kanji: jap.kanji != "" ? jap.kanji : nil,
                                           kana: jap.kana != "" ? jap.kana : nil,
                                           context: context))
        }
        
        for (i,sense) in strct.senses.enumerated() {
                
            var metaDatas:[MetaData] = []
            for metaData in sense.metaDatas {
                do {
                    metaDatas.append(try metaData.getEnumFormat())
                }
                catch {
                    fatalError(error.localizedDescription)
                }
            }
            
            var trads:[TraductionJMdict] = []
            for (i,trad) in sense.traductions.enumerated() {
                trads.append(TraductionJMdict(ordre: Int64(i),
                                              langue: Langue.init_(trad.langue),
                                              traductions: trad.traductions,
                                              context: context))
            }
            
            
            senses.append(SenseJMdict(ordre: Int64(i),
                                      metaDatas: metaDatas.isEmpty ? nil : metaDatas,
                                      traductions: trads.isEmpty ? nil : trads,
                                      context: context))
        }
        
        for (i,trad) in strct.noLangueTrads.enumerated() {
            
            noSenseTrads.append(TraductionJMdict(ordre: Int64(i),
                                                 langue: Langue.init_(trad.langue),
                                                 traductions: trad.traductions,
                                                 context: context))
        }
    
        self.init(odre: ordre,
                  jmDictID: Int64(strct.jmDictID),
                  uuid: UUID(uuidString: strct.uuid)!,
                  japonais: japonais.isEmpty ? nil : japonais,
                  senses: senses.isEmpty ? nil : senses,
                  noSenseTrads: noSenseTrads.isEmpty ? nil : noSenseTrads,
                  notes: nil,
                  context: context)
    }    
}



// MARK: Generated accessors for japonaisJMdictAtb
extension MotJMdict {

    @objc(addJaponaisJMdictAtbObject:)
    @NSManaged public func addToJaponaisJMdictAtb(_ value: JaponaisJMdict)

    @objc(removeJaponaisJMdictAtbObject:)
    @NSManaged public func removeFromJaponaisJMdictAtb(_ value: JaponaisJMdict)

    @objc(addJaponaisJMdictAtb:)
    @NSManaged public func addToJaponaisJMdictAtb(_ values: NSSet)

    @objc(removeJaponaisJMdictAtb:)
    @NSManaged public func removeFromJaponaisJMdictAtb(_ values: NSSet)

}

// MARK: Generated accessors for noSenseTradJMdictAtb
extension MotJMdict {

    @objc(addNoSenseTradJMdictAtbObject:)
    @NSManaged public func addToNoSenseTradJMdictAtb(_ value: TraductionJMdict)

    @objc(removeNoSenseTradJMdictAtbObject:)
    @NSManaged public func removeFromNoSenseTradJMdictAtb(_ value: TraductionJMdict)

    @objc(addNoSenseTradJMdictAtb:)
    @NSManaged public func addToNoSenseTradJMdictAtb(_ values: NSSet)

    @objc(removeNoSenseTradJMdictAtb:)
    @NSManaged public func removeFromNoSenseTradJMdictAtb(_ values: NSSet)

}

// MARK: Generated accessors for sensesJMdictAtb
extension MotJMdict {

    @objc(addSensesJMdictAtbObject:)
    @NSManaged public func addToSensesJMdictAtb(_ value: SenseJMdict)

    @objc(removeSensesJMdictAtbObject:)
    @NSManaged public func removeFromSensesJMdictAtb(_ value: SenseJMdict)

    @objc(addSensesJMdictAtb:)
    @NSManaged public func addToSensesJMdictAtb(_ values: NSSet)

    @objc(removeSensesJMdictAtb:)
    @NSManaged public func removeFromSensesJMdictAtb(_ values: NSSet)

}
