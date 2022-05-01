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

    
    
    @NSManaged public var joinedMetaDatasAtb: String?
    @NSManaged public var kanaAtb: String?
    @NSManaged public var kanjiAtb: String?
    @NSManaged public var parent: Mot?
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
            guard let newValue = newValue else { joinedMetaDatasAtb = nil ; return}
            let metaDatasStr:[String] = newValue.map {
                let metaStrc = MetaDataStruct($0)
                return "\(metaStrc.type)␞\(metaStrc.key)"
            }
            
            joinedMetaDatasAtb = metaDatasStr.joined(separator: "␀")
        }
    }
    
    var kanji: String? {
        get {
            return kanjiAtb
        }
        set {
            kanjiAtb = newValue
        }
    }
    
    var kana: String? {
        get {
            return kanaAtb
        }
        set {
            kanaAtb = newValue
        }
    }
    
    
    
    convenience init(ordre:Int64, kanji:String? = nil, kana:String? = nil, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.ordre = ordre
        
        self.kanji = kanji
        self.kana = kana
    }
}


