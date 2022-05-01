//
//  ImportationSheetView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/04/08.
//

import Foundation
import SwiftUI

struct ImportationSheetView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var loadedImiwaFile: SaveImiwa?
    @ObservedObject var listToImportIn: Liste
    
    var motAImporterJMdictIDs:Set<Int64> = []
    var kanjisAImporter:Set<String> = []
    
    init(loadedImiwaFile: SaveImiwa?, listToImportIn: ObservedObject<Liste>) {
        
        self.loadedImiwaFile = loadedImiwaFile
        _listToImportIn = listToImportIn
        
        for liste in loadedImiwaFile?.listes ?? [] {
            let result = countItem(liste: liste)
            
            motAImporterJMdictIDs.formUnion(result.motAImporterJMdictIDs)
            kanjisAImporter.formUnion(result.kanjisAImporter)
        }
    }
    
    var body: some View {
        
        if loadedImiwaFile != nil {
            ZStack {
                List {
                    Text("\(motAImporterJMdictIDs.count) Mots a importer")
                    Text("\(kanjisAImporter.count) Kanjis impossible a importer")
                }
                
                VStack {
                    Spacer()
                    
                    Button {
                        importSave()
                        dismiss()
                    } label: {
                        Text("Importer")
                            .foregroundColor(.white)
                            .frame(width: 250, height: 45)
                            .background(.blue)
                            .cornerRadius(5)
                    }
                    .padding()
                }
            }
        }
        else {
            Text("Aucun fichier chargé")
        }
    }
    
    func countItem(liste: SaveImiwaListe) -> (motAImporterJMdictIDs:Set<Int64>, kanjisAImporter:Set<String>) {
        
        var motAImporterJMdictIDs:Set<Int64> = []
        var kanjisAImporter:Set<String> = []
        
        if let values = liste.values {
            for value in values {
                if let JMdictID = Int64(value) {
                    motAImporterJMdictIDs.insert(JMdictID)
                }
                else {
                    kanjisAImporter.insert(value)
                }
            }
        }
        
        for liste in liste.subListes ?? [] {
            let result = countItem(liste: liste)
            
            motAImporterJMdictIDs.formUnion(result.motAImporterJMdictIDs)
            kanjisAImporter.formUnion(result.kanjisAImporter)
        }
        
        return (motAImporterJMdictIDs, kanjisAImporter)
        
    }
    
    
    func importSave() {
        
        let request = MotJMdict.fetchRequest(jmDictID: motAImporterJMdictIDs.map({ $0 }))
        let motsAImporter = try! DataController.shared.mainQueueManagedObjectContext.fetch(request)
        
        if let listes = loadedImiwaFile?.listes {
            
            for liste in listes {
                importListe(listeAImport: liste, importIn: listToImportIn)
            }
            
            
        }
        
        func importListe(listeAImport: SaveImiwaListe, importIn: Liste) {
            let liste = importIn.getOrCreateSousListe(name: listeAImport.name, context: DataController.shared.mainQueueManagedObjectContext)
            
            for value in listeAImport.values ?? [] {
                if let JMdictID = Int64(value) {
                    if let first = motsAImporter.first(where: { $0.jmDictID == JMdictID }) {
                        liste.addMot(first)
                    }
                }
            }
            
            for sousListe in listeAImport.subListes ?? [] {
                importListe(listeAImport: sousListe, importIn: liste)
            }
        }

    }
    
}






//struct ImportationSheetView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        Text("Background")
//            .sheet(isPresented: .constant(true)) {
//                ImportationSheetView(loadedImiwaFile: nil, listToImportIn: Liste())
//            }
//    }
//}
