//
//  ListeView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/19.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers


struct ListeView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.toggleSideMenu) var showSideMenu
    @Environment(\.metaDataDict) var metaDataDict
    @Environment(\.languesPref) var languesPref
    @Environment(\.languesAffichées) var languesAffichées
    @Environment(\.editMode) private var editMode
    

    @StateObject var liste: Liste
    
    @State var showAlert = false
    @State private var showFilePicker = false
    @State private var showImporterSheet = false
    @State private var showFileExporter = false
    
    @State private var loadedImiwaFile: SaveImiwa? = nil
    @State private var fileToExport: CSVForAnkiFile? = nil
    
        
    var body: some View {
        
        List {            
            if let sousListes = liste.sousListes {
                ForEach(sousListes) { liste in
                    
                    NavigationLink(liste.name ?? "No name") {
                        ListeView(liste: liste)
                    }
                    .isDetailLink(false)
                }
                .onDelete(perform: deleteSouListe)
            }
            
            if let mots = liste.mots {
                ForEach(mots) { mot in
                    NavigationLink(destination: MotDetailsView(mot: mot)) {
                        MotRowView(mot: mot)
                    }
                }
                .onDelete(perform: removeMot)
                .onMove(perform: liste.moveMot)
            }
        }.environment(\.editMode, editMode)
        
        .listStyle(.inset)
        .navigationTitle(liste.name ?? "No name")
        .navigationBarTitleDisplayMode(.inline)
        
        .alert(isPresented: $showAlert, TextAlert() { result in
            
            if let text = result {

                _ = self.liste.createSousListe(name: text, context: moc)
            }
            
        })
        .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [UTType("fileType.imiwa")!]) { result in
            do {
                let url = try result.get()
                importImiwaFile(url)
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
        .fileExporter(isPresented: $showFileExporter, document: fileToExport, contentType: UTType("fileType.CSVForAnki")!, defaultFilename: liste.name ?? "Jisho export") { result in
            switch result {
                
            case .success(_):
                print("success")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .sheet(isPresented: $showImporterSheet) {
            ImportationSheetView(loadedImiwaFile: self.loadedImiwaFile,
                                 listToImportIn: ObservedObject(wrappedValue: self.liste))
        }
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                sideMenuButton
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
                menuButton
            }
        }
    }
    
    private var sideMenuButton: some View {
        Button {
            showSideMenu()
        } label: {
            Image(systemName: "list.bullet")
        }
    }
    
    private var menuButton: some View {
        Menu
        {
            addButton
            importButton
            exportButton
        }
        label:
        {
            Image(systemName: "ellipsis.circle")
        }
        .padding([.leading,.bottom,.top])
    }
    
    private var addButton: some View {
        
        Button(action: {
            showAlert.toggle()
            
        }, label: {
            Label("Ajouter une sous liste", systemImage: "plus")
        })
    }
    
    private var importButton: some View {
        Button {
            showFilePicker.toggle()
        } label: {
            Label("Impoter save Imiwa", systemImage: "square.and.arrow.down")
        }

    }
    
    private var exportButton: some View {
        Button {
            if let mots = liste.mots {
                
                let motsPourExport = mots.map { mot -> (id: String, japs: [(kanji:String, kana:String)], senses: [(metaDatas:[String], traductions:[String])], traductions: [String], note: String ) in
            
                    let id = mot.uuid.uuidString
                    let japs = (mot.japonais ?? []).map { return (kanji: $0.kanji ?? "", kana: $0.kana ?? "") }
                    
                    let senses = (mot.senses ?? []).map {
                        (metaDatas: ($0.metaDatas ?? []).map { $0.description(metaDataDict.wrappedValue) },
                                                           
                         traductions: ($0.traductionsArray ?? [])
                            .compactMap {
                                if languesAffichées.wrappedValue.contains($0.langue) { return $0 }
                                else { return nil as Traduction? }
                            }
                            .sorted(languesPref.wrappedValue)
                            .map{ ($0.traductions ?? []).joined(separator: ", ") } )
                    }
                    
                    let traductions = (mot.noSenseTradsArray ?? [])
                        .compactMap {
                            if languesAffichées.wrappedValue.contains($0.langue) { return $0 }
                            else { return nil as Traduction? }
                        }
                        .sorted(languesPref.wrappedValue)
                        .map{ ($0.traductions ?? []).joined(separator: ", ") }
                    
                    let note = mot.notes ?? ""
                    
                    return (id: id, japs: japs, senses: senses, traductions: traductions, note: note)
                }
                
                self.fileToExport = CSVForAnkiFile(motsPourExport)
                self.showFileExporter.toggle()
            }
        } label: {
            Label("Exporter pour Anki", systemImage: "square.and.arrow.up")
        }
    }
    
    
    private func deleteSouListe(at offsets: IndexSet) {
        offsets.forEach{
            liste.deleteSousListe(liste: liste.sousListes![$0])
        }

    }
    
    private func importImiwaFile(_ fileURL: URL) {
        
        _ = fileURL.startAccessingSecurityScopedResource()
        
        do {
            self.loadedImiwaFile = try ImiwaSaveController.shared.loadFile(fileURL)
            self.showImporterSheet.toggle()
        }
        catch {
            fatalError(error.localizedDescription)
        }
        
        
        fileURL.stopAccessingSecurityScopedResource()
    }
    
    private func removeMot(at offsets: IndexSet) {
        offsets.forEach { index in
            liste.removeMot(at: index)
        }
    }
}
