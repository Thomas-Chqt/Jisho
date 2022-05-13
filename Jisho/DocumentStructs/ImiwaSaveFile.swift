//
//  ImiwaSaveFile.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/07.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct ImiwaSaveFile: FileDocument {
    
    static var readableContentTypes = [UTType("fileType.imiwa")!]
    
    fileprivate let brutImiwaSave: brutImiwaSave_backup
    fileprivate let imiwaSave: ImiwaSave
    
    lazy var numberOfItems: (importable: Int, nonImportable: Int) = {
        return (importable: 0, nonImportable: 0)
    }()
    
    
    init(fileURL: URL) throws {
        _ = fileURL.startAccessingSecurityScopedResource()

        let data = try Data(contentsOf: fileURL)
        
        do {
            self.brutImiwaSave = brutImiwaSave_backup(backup: try JSONDecoder().decode(brutImiwaSave_lists.self, from: data))
            self.imiwaSave = brutImiwaSave.backup.converted()
            fileURL.stopAccessingSecurityScopedResource()
        }
        catch {
            self.brutImiwaSave = try JSONDecoder().decode(brutImiwaSave_backup.self, from: data)
            self.imiwaSave = brutImiwaSave.backup.converted()
            fileURL.stopAccessingSecurityScopedResource()
        }
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else { throw ErrorPerso.readingFileError }
        
        do {
            self.brutImiwaSave = brutImiwaSave_backup(backup: try JSONDecoder().decode(brutImiwaSave_lists.self, from: data))
            self.imiwaSave = brutImiwaSave.backup.converted()
        }
        catch {
            self.brutImiwaSave = try JSONDecoder().decode(brutImiwaSave_backup.self, from: data)
            self.imiwaSave = brutImiwaSave.backup.converted()
        }
    }
    
    
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: try JSONEncoder().encode(brutImiwaSave))
    }
    
}





fileprivate struct ImiwaSave {
    var listes:[ImiwaListe]?
    var notes:[ImiwaNote]?
}

fileprivate struct ImiwaListe {
    var name: String
    var values: [String]?
    var subListes: [ImiwaListe]?
}

fileprivate struct ImiwaNote {
    var value: String
    var text: String?
}




fileprivate struct brutImiwaSave_backup: Codable {
    var backup: brutImiwaSave_lists
}

fileprivate struct brutImiwaSave_lists: Codable {
    var lists: [brutImiwaSave_listContainer]
    
    func converted() -> ImiwaSave {
        var listes:[ImiwaListe]?
        var notes:[ImiwaNote]?
        
        for listContainer in lists {
            if let list = listContainer.list {
                listes = (listes ?? []) + [list.converted()]
            }
            if let brutNoteItems = listContainer.notes?.items {
                notes = (notes ?? []) + brutNoteItems.map {
                    do {
                        return try $0.convertedInNote()
                    }
                    catch { fatalError(error.localizedDescription) }
                }
            }
        }
        
        return ImiwaSave(listes: listes, notes: notes)
    }
}

fileprivate struct brutImiwaSave_listContainer: Codable {
    var list: brutImiwaSave_list?
    var notes: brutImiwaSave_note?
}

fileprivate struct brutImiwaSave_list: Codable {
    var name: String
    var items: [brutImiwaSave_item]?
    var sublists: [brutImiwaSave_listContainer]?
    
    func converted() -> ImiwaListe {
        
        return ImiwaListe(name: name,
                          values: items?.map{ do { return try $0.convertInValue()}catch{fatalError(error.localizedDescription)} },
                          subListes: sublists?.map{ $0.list!.converted() })
    }
}

fileprivate struct brutImiwaSave_note: Codable {
    var items: [brutImiwaSave_item]?
}

fileprivate struct brutImiwaSave_item: Codable {
    var type: Int
    var value: String // jmdictID pour les items de liste, type-ID pour les items de note (mot: type = 0, ID = JMdictID / kanji: type = 2, ID = Kanji)
    var poortext: String?
    
    func convertInValue() throws -> String {
        if (type != 0) && (type != 2) { throw ErrorPerso.wrongType }
        return value
    }
    
    func convertedInNote() throws -> ImiwaNote {
        if type != 7 { throw ErrorPerso.wrongType }
        return ImiwaNote(value: value, text: poortext)
    }
}
