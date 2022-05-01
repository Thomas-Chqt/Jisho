//
//  SenseJMdict+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/03.
//
//

import Foundation
import CoreData

@objc(SenseJMdict)
public class SenseJMdict: Sense {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SenseJMdict> {
        return NSFetchRequest<SenseJMdict>(entityName: "SenseJMdict")
    }

    
    @NSManaged public var traductionsJMdictAtb: NSSet?
    @NSManaged public var parentJMdict: MotJMdict?
    
    
    
    override var metaDatas: [MetaData]? {
        get {
            super.metaDatas
        }

        set {
            fatalError("Cannot modify")
        }
    }
    
    override var traductionsArray: [Traduction]?{
        get {
            if traductionsJMdictAtb == nil { return nil }
            if traductionsJMdictAtb!.allObjects.isEmpty { return nil }

            let set = traductionsJMdictAtb as! Set<TraductionJMdict>
            let array = Array(set)
            return array//.sorted(savedLanguesPref)
        }
        set {
            fatalError("cannot modify")
        }
    }

    
    
    convenience init(ordre:Int64, metaDatas:[MetaData]? = nil, traductions:[TraductionJMdict]? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        self.ordre = ordre
        
        if let newValue = metaDatas {
            let metaDatasStr:[String] = newValue.map {
                let metaStrc = MetaDataStruct($0)
                return "\(metaStrc.type)␞\(metaStrc.key)"
            }
            
            joinedMetaDatasAtb = metaDatasStr.joined(separator: "␀")
        } else { joinedMetaDatasAtb = nil }
        
        for trad in traductions ?? [] {
            addToTraductionsJMdictAtb(trad)
        }
    }

}

// MARK: Generated accessors for traductionsJMdictAtb
extension SenseJMdict {

    @objc(addTraductionsJMdictAtbObject:)
    @NSManaged public func addToTraductionsJMdictAtb(_ value: TraductionJMdict)

    @objc(removeTraductionsJMdictAtbObject:)
    @NSManaged public func removeFromTraductionsJMdictAtb(_ value: TraductionJMdict)

    @objc(addTraductionsJMdictAtb:)
    @NSManaged public func addToTraductionsJMdictAtb(_ values: NSSet)

    @objc(removeTraductionsJMdictAtb:)
    @NSManaged public func removeFromTraductionsJMdictAtb(_ values: NSSet)

}
