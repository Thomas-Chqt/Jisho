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
    
    
    
    //MARK: NSManaged attributes

    @NSManaged private var parentJMdict: MotJMdict?

    
    
    //MARK: Modifiable Values (Only used in Init)
    
    private var modifiableKanji: String? {
        get {
            return super.kanji
        }

        set {
            super.kanji = newValue
        }
    }
    
    private var modifiableKana: String? {
        get {
            return super.kana
        }
        
        set {
            super.kana = newValue
        }
    }
    
    
    
    //MARK: Used Values
    
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
        
        self.modifiableKanji = kanji
        self.modifiableKana = kana
    }
    
//    static func == (lhs: JaponaisJMdict, rhs: Japonais) -> Bool {
//        return lhs.kanji == rhs.kanji && lhs.kana == rhs.kana
//    }
}
