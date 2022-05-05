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

    //MARK: NSManaged attributes
    
    @NSManaged private var joinedTradutionsAtb: String?
    @NSManaged private var langueStringAtb: String?
    @NSManaged private var ordreAtb: Int64
    
    @NSManaged private var motParent: Mot?
    @NSManaged private var senseParent: Sense?
    
    
    
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
    
    var langue: Langue {
        get{
            return Langue.init_(langueStringAtb)
        }
        set {
            objectWillChangeSend()
            langueStringAtb = newValue.rawValue
        }
    }
    
    var traductions: [String]? {
        get
        {
            return joinedTradutionsAtb?.components(separatedBy: "␀")
        }
        set
        {
            objectWillChangeSend()
            joinedTradutionsAtb = newValue?.joined(separator: "␀")
        }
    }
    
    
    
    //MARK: Functions
    
    func objectWillChangeSend() {
        self.objectWillChange.send()
        motParent?.objectWillChangeSend()
        senseParent?.objectWillChangeSend()
    }
    
    
    //MARK: Inits
    
    convenience init(ordre:Int64, langue:Langue = .none, traductions:[String]? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.ordre = ordre
        
        self.langue = langue
        self.traductions = traductions
    }
    
    
    static func == (lhs: Traduction, rhs: Traduction) -> Bool {
        return (lhs.langue == rhs.langue) && (lhs.traductions == rhs.traductions)
    }
}
