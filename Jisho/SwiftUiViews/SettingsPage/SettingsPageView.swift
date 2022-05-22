//
//  SettingsPageView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/19.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreData

fileprivate class SettingsPageViewModel: ObservableObject {
    @Published var showFileExporter = false
    @Published var showFileImporter = false
    @Published var showImportResumeSheet = false
    @Published var isSaving = false
    @Published var isLoading = false
    var importResumeSheetView: AnyView = AnyView(EmptyView())
    var saveFileForExport: JishoSaveFile? = nil
    
    func exportCompletion(result: Result<URL, Error> ) {
        switch result {
        case .success(let url):
            print(url)
            isSaving = false
            
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func saveAllListes() async throws{
        
        try await DataController.shared.mainQueueManagedObjectContext.perform {
            let request:NSFetchRequest<Liste> = Liste.fetchRequest()
            request.predicate = NSPredicate(format: "parent == nil")
            request.sortDescriptors = [NSSortDescriptor(key: "ordreInParentAtb", ascending: true)]
            
            let rootListes = try DataController.shared.mainQueueManagedObjectContext.fetch(request)
            self.saveFileForExport = JishoSaveFile(listes: rootListes)
        }
        
        self.showFileExporter.toggle()
    }
    
    func loadSaveFile(fileURL: URL) async throws {
        let importedJishoSaveFile = try JishoSaveFile(fileURL: fileURL)
        var uuidToObjIDDict:[UUID:NSManagedObjectID] = [:]
        let allMotToImportUUIDs = importedJishoSaveFile.savedData.allMotUUIDs
        let nbrListes = importedJishoSaveFile.savedData.nbrAllListe
        
        try await DataController.shared.privateQueueManagedObjectContext.perform {
            let requestMotPerso:NSFetchRequest<Mot> = Mot.fetchRequest(uuids: allMotToImportUUIDs)
            let requestMotJMdict:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest(uuids: allMotToImportUUIDs)
            
            let allMotAImport = try DataController.shared.privateQueueManagedObjectContext.fetch(requestMotPerso) +
                                       DataController.shared.privateQueueManagedObjectContext.fetch(requestMotJMdict)
            
            for mot in allMotAImport {
                uuidToObjIDDict[mot.uuid] = mot.objectID
            }
        }
        
        self.importResumeSheetView = AnyView(ImportResumeSheetView(nbrListes: nbrListes,
                                                                   nbrMots: uuidToObjIDDict.count,
                                                                   importAction: {
            var lastOrdre:Int64 = 0
            
            try await DataController.shared.privateQueueManagedObjectContext.perform {
                let request:NSFetchRequest<Liste> = Liste.fetchRequest()
                request.predicate = NSPredicate(format: "parent == nil")
                request.sortDescriptors = [NSSortDescriptor(key: "ordreInParentAtb", ascending: true)]
                lastOrdre = (try DataController.shared.privateQueueManagedObjectContext.fetch(request).last?.ordre ?? -1) + 1
            
                for liste in importedJishoSaveFile.savedData.listes {
                    let newListe = Liste(jishoSaveListe: liste, uuidToObjIDDict: uuidToObjIDDict, context: DataController.shared.privateQueueManagedObjectContext)
                    
                    newListe.ordre = lastOrdre
                    lastOrdre += 1
                }
            }
            
        } ))
        
        DispatchQueue.main.async { self.showImportResumeSheet.toggle() }
    }

    
    func fileImporterCompletion(result: Result<URL, Error>) {
        switch result {
        case .success(let fileURL):
            Task {
                try await loadSaveFile(fileURL: fileURL)
            }
            
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func importResumeCompletion() {
        self.isLoading = false
    }
}

struct SettingsPageView: View{
    
    @Environment(\.toggleSideMenu) var showSideMenu
    
    @StateObject private var vm = SettingsPageViewModel()

    
    var body: some View
    {
        List
        {
            NavigationLink("Meta datas", destination: MetaDatasEditorView())
            NavigationLink("Langues", destination: LanguesAffiche_View())
            if vm.isSaving { ProgressView() } else {
                Button("Sauvegarder") {
                    Task {
                        vm.isSaving = true
                        try await vm.saveAllListes()
                    }
                }
            }

            if vm.isLoading { ProgressView() } else {
                Button("Charger une sauvegarde") {
                    vm.isLoading = true
                    vm.showFileImporter.toggle()
                }
            }
            
            Section("Debug") {
                NavigationLink("Debug", destination: DebugMenu())
            }
        }
        .listStyle(.plain)
        .navigationTitle("Paramètres")
        .fileExporter(isPresented: $vm.showFileExporter, document: vm.saveFileForExport, contentType: UTType("fileType.JishoSaveFile")!, onCompletion: vm.exportCompletion)
        .fileImporter(isPresented: $vm.showFileImporter,
                      allowedContentTypes: [ UTType("fileType.JishoSaveFile")! ], onCompletion: vm.fileImporterCompletion)
        .sheet(isPresented: $vm.showImportResumeSheet, onDismiss: vm.importResumeCompletion) { vm.importResumeSheetView }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showSideMenu()
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationView {
            SettingsPageView()
        }
    }
}
