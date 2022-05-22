//
//  JishoSaveFile.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/16.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct JishoSaveFile: FileDocument {
    static var readableContentTypes: [UTType] = [ UTType("fileType.JishoSaveFile")! ]
    
    private var saveStruct: JishoSave
    
    
    var savedData: JishoSave {
        get {
            return saveStruct
        }
    }
    
    
    init(listes: [Liste]) {
        self.saveStruct = JishoSave(listes)
    }
    
    init(fileURL: URL) throws {
        _ = fileURL.startAccessingSecurityScopedResource()
        let brutData = try Data(contentsOf: fileURL)
        fileURL.stopAccessingSecurityScopedResource()
        self.saveStruct = try JSONDecoder().decode(JishoSave.self, from: brutData)
    }
    
    
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else { throw ErrorPerso.readingFileError }
        self.saveStruct = try JSONDecoder().decode(JishoSave.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(saveStruct)
        return FileWrapper(regularFileWithContents: data)
    }
    
    
    
    
}


struct JishoSave : Codable {
    var listes: [JishoSave_Liste]
    
    init(_ coreDataListes: [Liste]) {
        self.listes = coreDataListes.map { JishoSave_Liste($0) }
    }
    
    var allMotUUIDs: [UUID] {
        var uuids:[UUID] = []
        for liste in listes {
            uuids.append(contentsOf: liste.motsUUIDwithSubListe)
        }
        return uuids
    }
    
    var nbrAllListe: Int {
        var i = 0
        for liste in listes {
            i += 1
            i += liste.nbrSubListe
        }
        return i
    }
}

struct JishoSave_Liste : Codable {
    var name: String
    var sousListes: [JishoSave_Liste]
    var mots: [UUID]
    
    init(_ coreDataListe: Liste) {
        self.name = coreDataListe.name ?? "No name"
        self.sousListes = coreDataListe.sousListes?.map { JishoSave_Liste($0) } ?? []
        self.mots = coreDataListe.mots?.map { $0.uuid } ?? []
    }
    
    var motsUUIDwithSubListe: [UUID] {
        var uuids = mots
        for liste in sousListes {
            uuids.append(contentsOf: liste.motsUUIDwithSubListe)
        }
        return uuids
    }
    
    var nbrSubListe: Int {
        var i = 0
        for liste in sousListes {
            i += 1
            i += liste.nbrSubListe
        }
        return i
    }
}
