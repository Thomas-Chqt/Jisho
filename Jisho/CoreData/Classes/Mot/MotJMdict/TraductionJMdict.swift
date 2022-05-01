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

    
    
    @NSManaged public var motParentJMdict: MotJMdict?
    @NSManaged public var senseParentJMdict: SenseJMdict?

    
    
    override var langueString: String? {
        get{
            return super.langueString
        }
        set{
            fatalError("Cannot modify")
        }
    }
    
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
    
    
    
    convenience init(ordre:Int64, langue:Langue = .none, traductions:[String]? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.ordre = ordre
        
        self.langueStringAtb = langue.rawValue
        
        self.joinedTradutionsAtb = traductions?.joined(separator: "␀")
    }
}
