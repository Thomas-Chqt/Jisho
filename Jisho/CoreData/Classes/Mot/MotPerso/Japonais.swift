//
//  Japonais+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/28.
//
//

import Foundation
import CoreData

@objc(Japonais)
public class Japonais: NSManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Japonais> {
        return NSFetchRequest<Japonais>(entityName: "Japonais")
    }

    
    //MARK: NSManaged attributes
    
    @NSManaged private var kanaAtb: String?
    @NSManaged private var kanjiAtb: String?
    @NSManaged private var parent: Mot?
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
    
    var kanji: String? {
        get {
            return kanjiAtb
        }
        set {
            objectWillChangeSend()
            kanjiAtb = newValue
        }
    }
    
    var kana: String? {
        get {
            return kanaAtb
        }
        set {
            objectWillChangeSend()
            kanaAtb = newValue
        }
    }
    
    
    
    //MARK: Functions

    func objectWillChangeSend() {
        self.objectWillChange.send()
        parent?.objectWillChangeSend()
    }
    
    
    
    
    //MARK: Inits
    
    convenience init(ordre:Int64, kanji:String? = nil, kana:String? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.ordre = ordre
        
        self.kanji = kanji
        self.kana = kana
    }
    
    static func == (lhs: Japonais, rhs: Japonais) -> Bool {
        return lhs.kanji == rhs.kanji && lhs.kana == rhs.kana
    }
}


