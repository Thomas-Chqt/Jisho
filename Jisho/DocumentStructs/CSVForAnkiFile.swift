//
//  CSVForAnkiFile.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/08.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct CSVForAnkiFile: FileDocument {
    
    static var readableContentTypes = [UTType("fileType.CSVForAnki")!]
    
    var csvString = ""
    
    private init(_ mots: [Mot], metaDataDict: [MetaData : String?], languesPref: [Langue], languesAffichées: Set<Langue> ) {
        let tab = mots.map { mot -> (id: String, japs: [(kanji:String, kana:String)], senses: [(metaDatas:[String], traductions:[String])], traductions: [String], note: String ) in
    
            let id = mot.uuid.uuidString
            let japs = (mot.japonais ?? []).map { return (kanji: $0.kanji ?? "", kana: $0.kana ?? "") }
            
            let senses = (mot.senses ?? []).map {
                (metaDatas: ($0.metaDatas ?? []).map { $0.description(metaDataDict) },
                                                   
                 traductions: ($0.traductionsArray ?? [])
                    .compactMap {
                        if languesAffichées.contains($0.langue) { return $0 }
                        else { return nil as Traduction? }
                    }
                    .sorted(languesPref)
                    .map{ ($0.traductions ?? []).joined(separator: ", ") } )
            }
            
            let traductions = (mot.noSenseTradsArray ?? [])
                .compactMap {
                    if languesAffichées.contains($0.langue) { return $0 }
                    else { return nil as Traduction? }
                }
                .sorted(languesPref)
                .map{ ($0.traductions ?? []).joined(separator: ", ") }
            
            let note = mot.notes ?? ""
            
            return (id: id, japs: japs, senses: senses, traductions: traductions, note: note)
        }
        
        let date = Date().ISO8601Format()
        
        csvString = tab.map { (id: String, japs: [(kanji: String, kana: String)], senses: [(metaDatas: [String], traductions: [String])], traductions: [String] ,note: String) in
            return "\"\(id)\",\"\(japs.map{ "<p><div class=kana>\($0.kana)</div><div class=kanji>\($0.kanji)</div></p>" }.joined(separator: ""))\",\"\(senses.map{ "<p>\( $0.metaDatas.map{"<div class=metadata>\($0)</div>"}.joined(separator: "") )\( $0.traductions.map{"<div class=traductions>\($0)</div>"}.joined(separator: "") )</p>" }.joined(separator: ""))\",\"<p>\(traductions.map{ "<div class=autresTraductions>\($0)</div>" }.joined(separator: ""))</p>\",\"\(note)\",\"\(date)\""
        }
        .joined(separator: "\n")
    }
    
    init (mots: [Mot], settings: Settings) {
        self.init(mots, metaDataDict: settings.metaDataDict, languesPref: settings.languesPref, languesAffichées: settings.languesAffichées)
    }
    
    init(_ tab: [(id: String,
                  japs: [(kanji:String, kana:String)],
                  senses: [(metaDatas:[String], traductions:[String])],
                  traductions: [String],
                  note: String ) ] ) {
        
        
        let date = Date().ISO8601Format()
        
        csvString = tab.map { (id: String, japs: [(kanji: String, kana: String)], senses: [(metaDatas: [String], traductions: [String])], traductions: [String] ,note: String) in
            return "\"\(id)\",\"\(japs.map{ "<p><div class=kana>\($0.kana)</div><div class=kanji>\($0.kanji)</div></p>" }.joined(separator: ""))\",\"\(senses.map{ "<p>\( $0.metaDatas.map{"<div class=metadata>\($0)</div>"}.joined(separator: "") )\( $0.traductions.map{"<div class=traductions>\($0)</div>"}.joined(separator: "") )</p>" }.joined(separator: ""))\",\"<p>\(traductions.map{ "<div class=autresTraductions>\($0)</div>" }.joined(separator: ""))</p>\",\"\(note)\",\"\(date)\""
        }
        .joined(separator: "\n")
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents, let string = String(data: data, encoding: .utf8)
        else { throw CocoaError(.fileReadCorruptFile) }
        
        csvString = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: csvString.data(using: .utf8)!)
    }
    
    
    
    
    
    
}
