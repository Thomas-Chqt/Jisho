//
//  TraductionJMdict+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/07.
//
//

import Foundation
import CoreData

@objc(TraductionJMdict)
public class TraductionJMdict: Traduction {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TraductionJMdict> {
        return NSFetchRequest<TraductionJMdict>(entityName: "TraductionJMdict")
    }

    
    //MARK: NSManaged attributes

    @NSManaged public var motParentJMdict: MotJMdict?
    @NSManaged public var senseParentJMdict: SenseJMdict?

    
    
    //MARK: Modifiable Values (Only used in Init)

    private var modifiableLangue: Langue {
        get {
            super.langue
        }
        set {
            super.langue = newValue
        }
    }
    
    private var modifiableTraductions: [String]? {
        get {
            return super.traductions
        }
        set {
            super.traductions = newValue
        }
    }
    
    
    
    //MARK: Used Values

    override var langue: Langue {
        get {
            super.langue
        }
        set {
            fatalError("Cannot modify")
        }
    }
    
    override var traductions: [String]? {
        get {
            return super.traductions
        }
        set {
            fatalError("Cannot modify")
        }
    }
    
    
    
    convenience init(langue:Langue = .none, traductions:[String]? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.ordre = -99
        
        self.modifiableLangue = langue
        
        self.modifiableTraductions = traductions
    }
    
    
//    static func == (lhs: TraductionJMdict, rhs: Traduction) -> Bool {
//        print("trad equal func unsed")
//        return (lhs.langue == rhs.langue) && (lhs.traductions == rhs.traductions)
//    }
}
