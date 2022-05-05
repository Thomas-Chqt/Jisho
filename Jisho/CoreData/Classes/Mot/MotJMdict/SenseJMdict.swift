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
    
    
    //MARK: NSManaged attributes

    @NSManaged public var traductionsJMdictAtb: NSSet?
    @NSManaged public var parentJMdict: MotJMdict?
    
    
    
    //MARK: Modifiable Values (Only used in Init)

    private var modifiableMetaDatas: [MetaData]? {
        get {
            super.metaDatas
        }

        set {
            super.metaDatas = newValue
        }
    }
    
    private var modifiableTraductionsArray: [TraductionJMdict]?{
        get {
            if traductionsJMdictAtb == nil { return nil }
            if traductionsJMdictAtb!.allObjects.isEmpty { return nil }

            let set = traductionsJMdictAtb as! Set<TraductionJMdict>
            return set.sorted {
                $0.ordre < $1.ordre
            }
        }
        set {
            for trad in modifiableTraductionsArray ?? [] {
                removeFromTraductionsJMdictAtb(trad)
                self.managedObjectContext!.delete(trad)
            }
            for trad in newValue ?? [] {
                addToTraductionsJMdictAtb(trad)
            }
        }
    }
    
    
    
    //MARK: Used Values

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
            return set.sorted {
                $0.ordre < $1.ordre
            }
        }
        set {
            fatalError("cannot modify")
        }
    }

    
    
    convenience init(ordre:Int64, metaDatas:[MetaData]? = nil, traductions:[TraductionJMdict]? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        self.ordre = ordre
        
        modifiableMetaDatas = metaDatas
        modifiableTraductionsArray = traductions
    }

    
//    static func == (lhs: SenseJMdict, rhs: Sense) -> Bool {
//        print("sense equal func unsed")
//        return lhs.metaDatas == rhs.metaDatas && //lhs.traductionsArray == rhs.traductionsArray
//               lhs.traductionsArray?.map{$0.traductions} == rhs.traductionsArray?.map{$0.traductions} &&
//               lhs.traductionsArray?.map{$0.langue} == rhs.traductionsArray?.map{$0.langue}
//    }
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
