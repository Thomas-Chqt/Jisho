//
//  Traduction+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/07.
//
//

import Foundation
import CoreData

@objc(Traduction)
public class Traduction: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Traduction> {
        return NSFetchRequest<Traduction>(entityName: "Traduction")
    }

    
    
    @NSManaged public var joinedTradutionsAtb: String?
    @NSManaged public var langueStringAtb: String?
    @NSManaged public var ordre: Int64
    
    @NSManaged public var motParent: Mot?
    @NSManaged public var senseParent: Sense?
    
    
    
    var langueString: String? {
        get{
            return langueStringAtb
        }
        set{
            langueStringAtb = newValue
        }
    }
    
    var langue: Langue {
        get{
            return Langue.init_(langueString)
        }
        set {
            langueString = newValue.rawValue
        }
    }
    
    var traductions: [String]? {
        get
        {
            return joinedTradutionsAtb?.components(separatedBy: "␀")
        }
        set
        {
            joinedTradutionsAtb = newValue?.joined(separator: "␀")
        }
    }
    
    
    
    convenience init(ordre:Int64, langue:Langue = .none, traductions:[String]? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.ordre = ordre
        
        self.langue = langue
        self.traductions = traductions
    }
}
