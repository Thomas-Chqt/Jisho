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

    init (mots: [Mot], settings: Settings) {
        
        
        let tab = mots.map { mot -> (id: String,
                                     japs: [(kanji:String, kana:String)],
                                     senses: [(metaDatas:[String], traductions:String)],
                                     traductions: [String],
                                     note: String ) in
    
            let id = mot.uuid.uuidString
            let japs = mot.japonais?.map { (kanji: $0.kanji ?? "", kana: $0.kana ?? "") } ?? []
            
            let senses = mot.senses?.map {
                (
                    metaDatas: $0.metaDatas?
                        .map { $0.description(settings.metaDataDict) } ?? [],
                 
                    traductions: $0.traductionsArray?
                        .sortedCompacted(settings)
                        .first?
                        .traductions?
                        .joined(separator: ", ") ?? ""
                )
            } ?? []
            
            let traductions = mot.noSenseTradsArray?
                .sortedCompacted(settings)
                .map{ $0.traductions?.joined(separator: ", ") ?? "" } ?? []
            
            let note = mot.notes ?? ""
            
            return (id: id, japs: japs, senses: senses, traductions: traductions, note: note)
        }
        
        let date = Date().ISO8601Format()
        
        let htlmizedTab = tab.map { (id: String,
                                     japs: [(kanji: String, kana: String)],
                                     senses: [(metaDatas: [String], traductions: String)],
                                     traductions: [String],
                                     note: String) -> [String] in
            let A = id
            
            let B = japs
                .map { (kanji: String, kana: String) in
                    kana.addHtml(balise: .div, htlmClass: "kana") +
                    kanji.addHtml(balise: .div, htlmClass: "kanji")
                }
                .map { $0.addHtml(balise: .p)}
                .joined(separator: "")
            
            let C = senses
                .map { (metaDatas: [String], traductions: String) in
                    metaDatas.map { $0.addHtml(balise: .div, htlmClass: "metadata") }.joined(separator: "") +
                    traductions.addHtml(balise: .div, htlmClass: "traductions")
                }
                .map { $0.addHtml(balise: .p)}
                .joined(separator: "")
            
            let D = traductions
                .map { $0.addHtml(balise: .div, htlmClass: "autresTraductions")}
                .joined(separator: "")
            
            let E = note
            let F = date
            
            return [A,B,C,D,E,F]
        }
        
        self.csvString = htlmizedTab.csvString
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
