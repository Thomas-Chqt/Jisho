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
    
    
    
    //MARK: NSManaged attributes

    @NSManaged private var modifiedMotUUIDAtb: UUID?
    @NSManaged public var modifiedMotObjIDURi: URL?

    
    
    //MARK: Specifique to MotModifier

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
    
    var modifiedMot: MotJMdict {
        self.context.object(with: modifiedMotObjID) as! MotJMdict
    }
      
    
    
    override func objectWillChangeSend() {
        self.objectWillChange.send()
        modifiedMot.objectWillChange.send()
    }
    
    
    
    convenience init(ordre: Int64,
                     japonais:[Japonais]? = nil,
                     senses:[Sense]? = nil,
                     noSenseTrads:[Traduction]? = nil,
                     notes:String? = nil,
                     copiedMot: MotJMdict,
                     context:NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.modifiedMotUUID = copiedMot.uuid
        self.modifiedMotObjID = copiedMot.objectID
                
        self.uuid = UUID()
        self.ordre = ordre
        self.timestamp = Date()
        
        self.japonais = japonais
        self.senses = senses
        self.noSenseTradsArray = noSenseTrads
        self.notes = notes

        
    }
}


