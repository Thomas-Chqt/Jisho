//
//  MotModifier+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/28.
//
//

import Foundation
import CoreData

@objc(MotModifier)
public class MotModifier: Mot {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotModifier> {
        let fetchRequest = NSFetchRequest<MotModifier>(entityName: "MotModifier")
        fetchRequest.includesSubentities = false
        
        return fetchRequest
    }
    
    @nonobjc public override class func fetchRequest() -> NSFetchRequest<NSManagedObjectID> {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>(entityName: "MotModifier")
        fetchRequest.includesSubentities = false
        fetchRequest.resultType = .managedObjectIDResultType
        
        return fetchRequest
    }
    
    
    @nonobjc public class func fetchRequest(recherche:String) -> NSFetchRequest<MotModifier>{
        let fetchRequest:NSFetchRequest<MotModifier> = MotModifier.fetchRequest()
        fetchRequest.sortDescriptors = []
        
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
    
    @nonobjc public class func fetchRequest(modifiedMotObjID:NSManagedObjectID) -> NSFetchRequest<MotModifier> {
        let fetchRequest:NSFetchRequest<MotModifier> = MotModifier.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        fetchRequest.predicate = NSPredicate(format: "modifiedMotObjIDURi == %@", modifiedMotObjID.uriRepresentation() as CVarArg)
        
        return fetchRequest
    }
    
    @nonobjc public class func fetchRequest(modifiedMotUUID:UUID) -> NSFetchRequest<MotModifier> {
        let fetchRequest:NSFetchRequest<MotModifier> = MotModifier.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        fetchRequest.predicate = NSPredicate(format: "modifiedMotUUIDAtb == %@", modifiedMotUUID as CVarArg)

        
        return fetchRequest
    }
    
    
    //@NSManaged private var modifiedMotJMdictIDAtb: Int64
    @NSManaged private var modifiedMotUUIDAtb: UUID?
    @NSManaged public var modifiedMotObjIDURi: URL?

    
    var modifiedMotUUID: UUID {
        get {
            return modifiedMotUUIDAtb!
        }
        set {
            modifiedMotUUIDAtb = newValue
        }
    }
   
    
    var modifiedMotObjID: NSManagedObjectID {
        
        get {
            return DataController.shared.container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: modifiedMotObjIDURi!)!
        }
        set {
            modifiedMotObjIDURi = newValue.uriRepresentation()
        }
        
    }
    
    
    convenience init(_ copiedMot:MotJMdict) {
        
        var japonais:[Japonais]? = nil
        var senses:[Sense]? = nil
        var noSenseTrad:[Traduction]? = nil
        let notes:String? = copiedMot.notes
        
        var japArray:[Japonais] = []
        for jap in copiedMot.japonaisReel ?? [] {
            japArray.append(Japonais(ordre: jap.ordre,
                                     kanji: jap.kanji,
                                     kana: jap.kana,
                                     context: copiedMot.managedObjectContext!))
        }
        if japArray.count > 0 { japonais = japArray }
        
        var sensesArray:[Sense] = []
        for sense in copiedMot.sensesReel ?? []{
            var traductions:[Traduction]? = nil
            
            var tradArry:[Traduction] = []
            for trad in sense.traductionsArray ?? []{
                tradArry.append(Traduction(ordre: trad.ordre,
                                           langue: trad.langue,
                                           traductions: trad.traductions,
                                           context: copiedMot.managedObjectContext!))
            }
            if tradArry.count > 0 { traductions = tradArry }
            
            sensesArray.append(Sense(ordre: sense.ordre,
                                     metaDatas: sense.metaDatas,
                                     traductions: traductions,
                                     context: copiedMot.managedObjectContext!))
        }
        if sensesArray.count > 0 { senses = sensesArray }
        
        for trad in copiedMot.noSenseTradsArrayReel ?? [] {
            
            if noSenseTrad == nil { noSenseTrad = [] }
            
            noSenseTrad!.append(Traduction(ordre: trad.ordre,
                                           langue: trad.langue,
                                           traductions: trad.traductions,
                                           context: copiedMot.managedObjectContext!))
        }
        
        self.init(odre: copiedMot.ordre,
                  japonais: japonais,
                  senses: senses,
                  noSenseTrads: noSenseTrad,
                  notes: notes,
                  context: copiedMot.managedObjectContext!)

        self.modifiedMotUUID = copiedMot.uuid
        self.modifiedMotObjID = copiedMot.objectID
    }
}


