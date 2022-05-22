//
//  Sense+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/28.
//
//

import Foundation
import CoreData

@objc(Sense)
public class Sense: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sense> {
        return NSFetchRequest<Sense>(entityName: "Sense")
    }

    
    //MARK: NSManaged attributes
    
    @NSManaged private var joinedMetaDatasAtb: String?
    @NSManaged private var parent: Mot?
    @NSManaged private var traductionsAtb: NSSet?
    @NSManaged private var ordreAtb: Int64
    
    
    
    //MARK: Not override in children

    var ordre: Int64 {
        get {
            return ordreAtb
        }
        set {
            ordreAtb = newValue
        }
    }
    
    var context: NSManagedObjectContext {
        guard let context = self.managedObjectContext else { fatalError() }
        return context
    }

    
    
    //MARK: Override in children

    var metaDatas: [MetaData]? {
        get {
            do {
                guard let joinedMetaDatas = joinedMetaDatasAtb else {return nil}
                let metaDatasStr:[String] = joinedMetaDatas.components(separatedBy: "␀")
                let metaDatasArray:[MetaData] = try metaDatasStr.map {
                    try MetaDataStruct( type: $0.components(separatedBy: "␞")[0],
                                        key: $0.components(separatedBy: "␞")[1] ).getEnumFormat()
                }
                
                return metaDatasArray
            }
            catch { fatalError() }
        }
        
        set {
            objectWillChangeSend()
            
            if let newValue = newValue {
                let metaDatasStr:[String] = newValue.map {
                    let metaStrc = MetaDataStruct($0)
                    return "\(metaStrc.type)␞\(metaStrc.key)"
                }
                
                joinedMetaDatasAtb = metaDatasStr.joined(separator: "␀")
            } else { joinedMetaDatasAtb = nil }
        }
    }
    
    var traductionsArray: [Traduction]? {
        get {
            if traductionsAtb == nil { return nil }
            if traductionsAtb!.allObjects.isEmpty { return nil }

            let set = traductionsAtb as! Set<Traduction>
            return set.sorted {
                $0.ordre < $1.ordre
            }
        }
        set {
            objectWillChangeSend()
            
            for (i, value) in (newValue ?? []).enumerated() {
                value.ordre = Int64(i)
            }
            
            for trad in newValue ?? [] {
                if !(traductionsArray ?? []).contains(trad) {
                    addToTraductionsAtb(trad)
                }
            }
            for trad in traductionsArray ?? [] {
                if !(newValue ?? []).contains(trad) {
                    removeFromTraductionsAtb(trad)
                    self.context.delete(trad)
                }
            }
        }
    }
    
    
    
    //MARK: Functions

    func objectWillChangeSend() {
        self.objectWillChange.send()
        parent?.objectWillChangeSend()
    }
        
    
    
    //MARK: Inits
    
    convenience init(metaDatas:[MetaData]? = nil, traductions:[Traduction]? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.ordre = -99
        
        self.metaDatas = metaDatas
        self.traductionsArray = traductions
    }
    
    static func == (lhs: Sense, rhs: Sense) -> Bool {
        return lhs.metaDatas == rhs.metaDatas && lhs.traductionsArray == rhs.traductionsArray
    }
}



// MARK: Generated accessors for traductionsAtb
extension Sense {

    @objc(addTraductionsAtbObject:)
    @NSManaged public func addToTraductionsAtb(_ value: Traduction)

    @objc(removeTraductionsAtbObject:)
    @NSManaged public func removeFromTraductionsAtb(_ value: Traduction)

    @objc(addTraductionsAtb:)
    @NSManaged public func addToTraductionsAtb(_ values: NSSet)

    @objc(removeTraductionsAtb:)
    @NSManaged public func removeFromTraductionsAtb(_ values: NSSet)

}
