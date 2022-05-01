//
//  JaponaisJMdict+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/03.
//
//

import Foundation
import CoreData

@objc(JaponaisJMdict)
public class JaponaisJMdict: Japonais {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<JaponaisJMdict> {
        return NSFetchRequest<JaponaisJMdict>(entityName: "JaponaisJMdict")
    }
    
    
    
    @NSManaged public var parentJMdict: MotJMdict?

    
    
    override var kanji: String? {
        get {
            return super.kanji
        }

        set {
            fatalError("Cannot modify")
        }
    }
    
    override var kana: String? {
        get {
            return super.kana
        }
        
        set {
            fatalError("Cannot modify")
        }
    }

    
    
    convenience init(ordre:Int64, kanji:String? = nil, kana:String? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.ordre = ordre
        
        self.kanjiAtb = kanji
        self.kanaAtb = kana
    }
    
    
}
