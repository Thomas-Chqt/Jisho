//
//  ImiwaSaveController.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/04/07.
//

import Foundation

class ImiwaSaveController {
    
    public static let shared = ImiwaSaveController()
    
    
    func loadFile(_ fileURL: URL) throws -> SaveImiwa {
        do {
            return try ImiwaSaveController.shared.loadSave(fileURL)
        }
        catch {
            do {
                return try ImiwaSaveController.shared.loadLists(fileURL)
            }
            catch {
                throw error
            }
        }
    }
    
    
    
    private func loadSave(_ fileURL: URL) throws -> SaveImiwa {
        let brutSave = try parsImiwaSave(fileURL)
        return convertBrutSave(brutSave)
    }
    
    private func loadLists(_ fileURL: URL) throws -> SaveImiwa {
        let brutLists = try parsImiwaLists(fileURL)
        
        var listes:[BrutSaveImiwaListStrct] = []

        for liste in brutLists.lists {
            
            if let liste = liste["list"] {
                listes.append(liste)
            }
        }
        
        return SaveImiwa(listes: listes.isEmpty ? nil : listes.map{ convertBrutList($0) },
                         notes: nil)
    }
    
    
    private func parsImiwaSave(_ file:URL) throws -> BrutSaveImiwa {
        do{
            let brutData = try Data(contentsOf: file)
            let decodedData = try JSONDecoder().decode(BrutSaveImiwa.self, from: brutData)
            return decodedData
        }
        catch{
            throw error
        }
    }
    
    private func parsImiwaLists(_ file:URL) throws -> BrutSaveImiwaBackupStrct {
        do{
            let brutData = try Data(contentsOf: file)
            let decodedData = try JSONDecoder().decode(BrutSaveImiwaBackupStrct.self, from: brutData)
            return decodedData
        }
        catch{
            throw error
        }
    }
    
    
    private func convertBrutSave(_ brutSave: BrutSaveImiwa) -> SaveImiwa {
        
        let backup = brutSave.backup
        
        var listes:[BrutSaveImiwaListStrct] = []
        var notes:[BrutSaveImiwaItemStrct] = []
        
        for liste in backup.lists {
            
            if let liste = liste["list"] {
                listes.append(liste)
            }
            
            if let notes_ = liste["notes"] {
                notes = notes_.items!
            }
        }
                
        return SaveImiwa(listes: listes.isEmpty ? nil : listes.map{ convertBrutList($0) },
                         notes: notes.isEmpty ? nil : notes.map{ convertBrutNote($0) } )
    }
    
    private func convertBrutList(_ brutList: BrutSaveImiwaListStrct) -> SaveImiwaListe {
        
        let name = brutList.name ?? "No name"
        
        let values = brutList.items?.map({
            return $0.value
        })
        
        let subListes = brutList.sublists?.map({
            return convertBrutList($0["list"]!)
        })
        
        return SaveImiwaListe(name: name, values: values, subListes: subListes)
    }
    
    private func convertBrutNote(_ brutNote: BrutSaveImiwaItemStrct) -> SaveImiwaNote {
        
            return SaveImiwaNote(value: brutNote.value,
                                 text: brutNote.poortext ?? "")
        
    }
}



fileprivate struct BrutSaveImiwa: Codable {
    
    
    fileprivate var backup:BrutSaveImiwaBackupStrct
    
}


fileprivate struct BrutSaveImiwaBackupStrct: Codable {
    fileprivate var lists:[[String:BrutSaveImiwaListStrct]]
}


fileprivate struct BrutSaveImiwaListStrct: Codable {
    var name:String?
    var items: [BrutSaveImiwaItemStrct]?
    var sublists:[[String:BrutSaveImiwaListStrct]]?
}


fileprivate struct BrutSaveImiwaItemStrct: Codable {
    var value:String
    var type: Int
    var poortext: String?
}





