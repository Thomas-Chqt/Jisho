//
//  ListeView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/19.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

fileprivate class ListeViewModel: ObservableObject {
        
    @Published var showFilePicker = false
    @Published var importedImiwaSaveFile: ImiwaSaveFile? = nil
    @Published var showImportResumeSheet = false
    
    @Published var fileToExport: CSVForAnkiFile? = nil
    @Published var showFileExporter = false
    
    @Published var showTextField = false
    @Published var textFieldText = ""
    
    
    func filePicked(result: Result<URL, Error>) {
        do {
            let url = try result.get()
            importedImiwaSaveFile = try ImiwaSaveFile(fileURL: url)
            showImportResumeSheet.toggle()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func export(file: CSVForAnkiFile) {
        fileToExport = file
        showFileExporter.toggle()
    }
    
    func fileExported(result: Result<URL, Error>) {
        switch result {
            
        case .success(_):
            print("success")
            
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}


struct ListeView: View {
    
    @Environment(\.toggleSideMenu) var showSideMenu
    @Environment(\.editMode) private var editMode
    
    @EnvironmentObject private var settings: Settings
    
    @StateObject private var vm = ListeViewModel()
    
    @ObservedObject var liste: Liste
        
    var body: some View {
        
        List {            
            if let sousListes = liste.sousListes {
                ForEach(sousListes) { liste in
                    
                    NavigationLink("\(liste.name ?? "No name")") {
                        ListeView(liste: liste)
                    }
                    .isDetailLink(false)
                }
                .onDelete(perform: deleteSouListe)
                .onMove(perform: moveSousListe)
            }
            
            if vm.showTextField {
                TextField("Nouvelle liste", text: $vm.textFieldText)
                    .onSubmit { textFieldSubmited() }
            }
            
            if let mots = liste.mots {
                ForEach(mots) { mot in
                    NavigationLink(destination: MotDetailsView(mot: mot)) {
                        MotRowView(mot: mot)
                    }
                }
                .onDelete(perform: removeMot)
                .onMove(perform: moveMot)
            }
            
            
        }.environment(\.editMode, editMode)
        
        .listStyle(.inset)
        .navigationTitle(liste.name ?? "No name")
        .navigationBarTitleDisplayMode(.inline)
        
        .fileImporter(isPresented: $vm.showFilePicker, allowedContentTypes: [UTType("fileType.imiwa")!], onCompletion: vm.filePicked)
        .fileExporter(isPresented: $vm.showFileExporter, document: vm.fileToExport, contentType: UTType("fileType.CSVForAnki")!,
                      defaultFilename: liste.name ?? "Jisho export", onCompletion: vm.fileExported)
        .sheet(isPresented: $vm.showImportResumeSheet) { EmptyView() }
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button { showSideMenu() } label: { Image(systemName: "list.bullet") }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
                menuButton
            }
        }
    }
    
    private var menuButton: some View {
        Menu {
            Button { vm.showTextField = true } label: { Label("Ajouter une sous liste", systemImage: "plus") }
//            Button { vm.showFilePicker.toggle() } label: { Label("Importer save Imiwa", systemImage: "square.and.arrow.down") }
            exportButton
        }
        label: {
            Image(systemName: "ellipsis.circle")
        }
        .padding([.leading,.bottom,.top])
    }
    
    private var exportButton: some View {
        Button {
            if let mots = liste.mots {
                vm.export(file: CSVForAnkiFile(mots: mots, settings: settings))
            }
        } label: {
            Label("Exporter pour Anki", systemImage: "square.and.arrow.up")
        }
    }
    
    
    private func deleteSouListe(at offsets: IndexSet) {
        liste.sousListes?.remove(atOffsets: offsets)
    }
    
    private func removeMot(at offsets: IndexSet) {
        liste.mots?.remove(atOffsets: offsets)
    }
    
    private func moveMot(sources: IndexSet, destination: Int) {
        liste.mots?.move(fromOffsets: sources, toOffset: destination)
    }
    
    private func moveSousListe(sources: IndexSet, destination: Int) {
        liste.sousListes?.move(fromOffsets: sources, toOffset: destination)
    }
    
    
    private func textFieldSubmited() {
        if vm.textFieldText != "" {
            liste.sousListes = (liste.sousListes ?? []) + [ Liste(name: vm.textFieldText, context: DataController.shared.mainQueueManagedObjectContext) ]
            vm.textFieldText = ""
            vm.showTextField = false
        }
    }
}
