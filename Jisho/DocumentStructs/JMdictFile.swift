//
//  JMdictFile.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/14.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import CoreData

struct JMdictFile: FileDocument {
    static var readableContentTypes: [UTType] = [ UTType("fileType.JMdictFile")! ]
    
    fileprivate var mots: [MotImporter]
    
    init(fileURL: URL) async throws {
        let brutData = try Data(contentsOf: fileURL)
        self.mots = try JSONDecoder().decode([MotImporter].self, from: brutData)
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else { throw ErrorPerso.readingFileError }
        
        self.mots = try JSONDecoder().decode([MotImporter].self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(mots)
        return FileWrapper(regularFileWithContents: data)
    }
    
    func createMotsJMdict(percentCallback: (Int) -> Void) {
        for (i, mot) in mots.enumerated() {
            
            let ordre = Int64(i), strct = mot, context = DataController.shared.privateQueueManagedObjectContext
            
            var japonais:[JaponaisJMdict] = []
            var senses:[SenseJMdict] = []
            var noSenseTrads:[TraductionJMdict] = []
            
            for (_,jap) in strct.japonais.enumerated() {
                japonais.append(JaponaisJMdict(/*ordre: Int64(i),*/
                                               kanji: jap.kanji != "" ? jap.kanji : nil,
                                               kana: jap.kana != "" ? jap.kana : nil,
                                               context: context))
            }
            
            for (_,sense) in strct.senses.enumerated() {
                    
                var metaDatas:[MetaData] = []
                for metaData in sense.metaDatas {
                    do {
                        metaDatas.append(try metaData.getEnumFormat())
                    }
                    catch {
                        fatalError(error.localizedDescription)
                    }
                }
                
                var trads:[TraductionJMdict] = []
                for (_,trad) in sense.traductions.enumerated() {
                    trads.append(TraductionJMdict(/*ordre: Int64(i),*/
                                                  langue: Langue.init_(trad.langue),
                                                  traductions: trad.traductions,
                                                  context: context))
                }
                
                
                senses.append(SenseJMdict(/*ordre: Int64(i),*/
                                          metaDatas: metaDatas.isEmpty ? nil : metaDatas,
                                          traductions: trads.isEmpty ? nil : trads,
                                          context: context))
            }
            
            for (_,trad) in strct.noLangueTrads.enumerated() {
                
                noSenseTrads.append(TraductionJMdict(/*ordre: Int64(i),*/
                                                     langue: Langue.init_(trad.langue),
                                                     traductions: trad.traductions,
                                                     context: context))
            }
        
            _ = MotJMdict(odre: ordre,
                          jmDictID: Int64(strct.jmDictID),
                          uuid: UUID(uuidString: strct.uuid)!,
                          japonais: japonais.isEmpty ? nil : japonais,
                          senses: senses.isEmpty ? nil : senses,
                          noSenseTrads: noSenseTrads.isEmpty ? nil : noSenseTrads,
                          notes: nil,
                          context: context)
            
            if ((i+1) % (mots.count / 100)) == 0 {
                percentCallback((i + 1) / (mots.count / 100))
            }
        }
    }
}



fileprivate struct MotImporter: Codable {
    var jmDictID:Int
    var uuid:String
    var japonais:[JaponaisImporter]
    var senses:[SenseImporter]
    var noLangueTrads:[TraductionImporter]
}

fileprivate struct JaponaisImporter: Codable {
    var metaDatas:[MetaDataStruct]
    var kanji:String
    var kana:String
}

fileprivate struct SenseImporter: Codable {
    var metaDatas:[MetaDataStruct]
    var traductions:[TraductionImporter]
}

fileprivate struct TraductionImporter: Codable {
    var langue: String
    var traductions: [String]
}
