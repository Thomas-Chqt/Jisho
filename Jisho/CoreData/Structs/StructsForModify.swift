//
//  MotStructForModify.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/01.
//

import Foundation


struct MotStruct: Equatable, Identifiable {
    
    var id = UUID()

    var japonais:[JaponaisStruct] = []
    var senses:[SenseStruct] = []
    var noLangueTrads:[TraductionStruct] = []
    var notes:String = ""
    
    
    init(_ motCopied:Mot)
    {
        self.japonais = motCopied.japonais?.map {
            JaponaisStruct(kanji: $0.kanji ?? "", kana: $0.kana ?? "")
        } ?? []
        
        
        self.senses = motCopied.senses?.map {
            SenseStruct(metaDatas: $0.metaDatas ?? [],
                        traductionsArray: $0.traductionsArray?/*.sorted(Settings.shared.languesPref)*/.map {
                            TraductionStruct(langue: $0.langue,
                                             traductions: $0.traductions?.joined(separator: ", ") ?? "" )
                            } ?? [])
        } ?? []
        
        
        self.noLangueTrads = motCopied.noSenseTradsArray?/*.sorted(Settings.shared.languesPref)*/.map {
            TraductionStruct(langue: $0.langue, traductions: $0.traductions?.joined(separator: ", ") ?? "")
        } ?? []
        
        self.notes = motCopied.notes ?? ""
    }
    
    init()
    {
        self.japonais = []
        self.senses = []
        self.noLangueTrads = []
        self.notes = ""
    }

    static func == (left: MotStruct, right: MotStruct) -> Bool {
        
        return  (left.japonais == right.japonais) &&
                (left.senses == right.senses) &&
                (left.noLangueTrads == right.noLangueTrads) &&
                (left.notes == right.notes)
    }
}


struct JaponaisStruct: Equatable, Identifiable {
    var id = UUID()

    var kanji: String = ""
    var kana: String = ""

    static func == (left: JaponaisStruct, right: JaponaisStruct) -> Bool {
        return  (left.kanji == right.kanji) && (left.kana == right.kana)
    }
}


struct SenseStruct: Equatable, Identifiable {
    var id = UUID()

    var metaDatas: [MetaData] = []
    var traductionsArray:[TraductionStruct] = []
    

    static func == (left: SenseStruct, right: SenseStruct) -> Bool {
        return  (left.metaDatas == right.metaDatas) && (left.traductionsArray == right.traductionsArray)
    }
}


struct TraductionStruct: Equatable, Identifiable {
    var id = UUID()

    var langue:Langue = .none
    var traductions:String = ""

    static func == (left: TraductionStruct, right: TraductionStruct) -> Bool {
        return  (left.langue == right.langue) && (left.traductions == right.traductions)
    }
    
    static func == (left: TraductionStruct, right: Traduction) -> Bool {
        return  (left.langue == right.langue) && (left.traductions == (right.traductions ?? []).joined(separator: ", "))
    }
}

