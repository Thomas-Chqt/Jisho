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

    
    
    @NSManaged public var joinedMetaDatasAtb: String?
    @NSManaged public var parent: Mot?
    @NSManaged public var traductionsAtb: NSSet?
    @NSManaged public var ordre: Int64
    
    
    
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
            let array = Array(set)
            return array//.sorted(savedLanguesPref)
        }
        set {
            for trad in traductionsArray ?? [] {
                removeFromTraductionsAtb(trad)
                self.managedObjectContext!.delete(trad)
            }
            for trad in newValue ?? [] {
                addToTraductionsAtb(trad)
            }
        }
    }
        
    
    convenience init(ordre:Int64, metaDatas:[MetaData]? = nil, traductions:[Traduction]? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.ordre = ordre
        
        self.metaDatas = metaDatas
        self.traductionsArray = traductions
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
