//
//  MotStrcImporter.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/16.
//

import Foundation


struct MotImporter: Codable {
    var jmDictID:Int
    var uuid:String
    var japonais:[JaponaisImporter]
    var senses:[SenseImporter]
    var noLangueTrads:[TraductionImporter]
}

struct JaponaisImporter: Codable {
    var metaDatas:[MetaDataStruct]
    var kanji:String
    var kana:String
}

struct SenseImporter: Codable {
    var metaDatas:[MetaDataStruct]
    var traductions:[TraductionImporter]
}

struct TraductionImporter: Codable {
    var langue: String
    var traductions: [String]
}


