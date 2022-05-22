//
//  DebugActionsView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/14.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

fileprivate class DebugActionsViewModel: ObservableObject {
    
    @Published var loadingStatus: LoadingStatus = .finished
    @Published var showFileImporter = false
    
    func fileImporterCompletion(result: Result<URL, Error>) {
        switch result {
        case .failure(let error):
            fatalError(error.localizedDescription)
        case .success(let url):
            Task {
                do {
                    try await reImportJMdict(url)
                }
                catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    func reCreateSearchTables() {
        Task {
            DispatchQueue.main.async {
                self.loadingStatus = .loading("Deleting search Tables")
            }
            
            try await deleteAllSearchTables()
            
            DispatchQueue.main.async {
                self.loadingStatus = .loading("Ceating search tables")
            }
            
            guard let searchTablesIDsManquantes = try await getSearchTablesIDsManquantes() else { return }
            
            let allKeyWordManquant = try await getAllKeyWordManquant(tableManquantesIDs: searchTablesIDsManquantes)
            
            for id in searchTablesIDsManquantes.sorted() {
                try await createSearcheTable(allKeyWordManquant: allKeyWordManquant, id: id, nbrTableACree: searchTablesIDsManquantes.count)
            }
            
            DispatchQueue.main.async { self.loadingStatus = .loading("Saving") }

            try await DataController.shared.save()
            
            DispatchQueue.main.async { self.loadingStatus = .finished }

        }
        
    }
    
    
    
    private func reImportJMdict(_ fileURL: URL) async throws {
        DispatchQueue.main.async {
            self.loadingStatus = .loading("Deleting")
        }
        
        try await deleteAllMotJMDict()
        
        DispatchQueue.main.async {
            self.loadingStatus = .loading("Importing")
        }
        
        try await importJMdict(fileURL: fileURL)
        
        DispatchQueue.main.async {
            self.loadingStatus = .loading("Saving")
        }
        
        try await DataController.shared.save()
        
        DispatchQueue.main.async {
            self.loadingStatus = .finished
        }
    }
    
    private func deleteAllMotJMDict() async throws {
        try await DataController.shared.privateQueueManagedObjectContext.perform {
            let request:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest()
            request.includesPropertyValues = false
            
            let allMotJMDict = try DataController.shared.privateQueueManagedObjectContext.fetch(request)
            
            for mot in allMotJMDict {
                DataController.shared.privateQueueManagedObjectContext.delete(mot)
            }
        }
    }
    
    private func importJMdict(fileURL: URL) async throws {
        
        DispatchQueue.main.async {
            self.loadingStatus = .loading("Parsing")
        }

        _ = fileURL.startAccessingSecurityScopedResource()
        
        let JMdictFile = try await JMdictFile(fileURL: fileURL)
        
        fileURL.stopAccessingSecurityScopedResource()

        await DataController.shared.privateQueueManagedObjectContext.perform {
            JMdictFile.createMotsJMdict { percent in
                DispatchQueue.main.async {
                    self.loadingStatus = .loadingPercent("Creating", percent)
                }
            }
        }
        
    }
    
    
    
    private func deleteAllSearchTables() async throws {
        try await DataController.shared.privateQueueManagedObjectContext.perform {
            let request:NSFetchRequest<NSManagedObjectID> = SearchTableHolderMotJMdict.fetchRequest()
            request.includesPropertyValues = false
            
            let allSearchTablesObjIDs = try DataController.shared.privateQueueManagedObjectContext.fetch(request)
            
            for tableObjID in allSearchTablesObjIDs {
                let table = DataController.shared.privateQueueManagedObjectContext.object(with: tableObjID)
                DataController.shared.privateQueueManagedObjectContext.delete(table)
                try DataController.shared.privateQueueManagedObjectContext.save()
            }
        }
    }
    
    private func getSearchTablesIDsManquantes() async throws -> Set<Int>? {
        
        try await DataController.shared.privateQueueManagedObjectContext.perform {
            let request:NSFetchRequest<SearchTableHolderMotJMdict> = SearchTableHolderMotJMdict.fetchRequest()
            let existingSearchTablesIDs = (try DataController.shared.privateQueueManagedObjectContext.fetch(request)).map { Int($0.idAtb) }
            
            var nonExisting = Array(0...999)
            nonExisting.removeAll(where: { existingSearchTablesIDs.contains($0) })
            
            return nonExisting.isEmpty ? nil : Set(nonExisting)
        }

    }
    
    private func getAllKeyWordManquant(tableManquantesIDs: Set<Int>) async throws -> [String:Set<NSManagedObjectID>] {
        
        try await DataController.shared.privateQueueManagedObjectContext.perform {
            
            DispatchQueue.main.async { self.loadingStatus = .loading("Getting all keyWords") }

            let request:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest()
            let allMotJMdict = try DataController.shared.privateQueueManagedObjectContext.fetch(request)
                                
            try DataController.shared.privateQueueManagedObjectContext.obtainPermanentIDs(for: allMotJMdict)
            
            var searchTable:[String:Set<NSManagedObjectID>] = [:]
            
            DispatchQueue.main.async { self.loadingStatus = .loadingPercent("Getting all keyWords", 0) }
            
            for (i, mot) in allMotJMdict.enumerated() {
                
                for keyWord in self.getKeyWords(mot) {
                                        
                    var hash = keyWord.hash
                    if hash < 0 { hash *= -1 }
                    
                    if tableManquantesIDs.contains(hash % 1000) {
                        searchTable[keyWord] = (searchTable[keyWord] ?? []).union([ mot.objectID ])
                    }
                    
                    if ((i+1) % (allMotJMdict.count / 100)) == 0 {
                        DispatchQueue.main.async {
                            self.loadingStatus = .loadingPercent( "Getting all keyWords", ( (i + 1) / (allMotJMdict.count / 100) ) )
                        }
                    }
                }
            }
            
            return searchTable
        }
    
    }
    
    private func createSearcheTable( allKeyWordManquant: [String:Set<NSManagedObjectID>], id:Int, nbrTableACree: Int) async throws {
        
        try await DataController.shared.privateQueueManagedObjectContext.perform {
            
            var searchTable:[String:Set<NSManagedObjectID>] = [:]
            
            DispatchQueue.main.async { self.loadingStatus = .loadingPercent( "creating search table \(id) / \(nbrTableACree - 1)", 0 ) }

            for (i, keyWord) in allKeyWordManquant.keys.enumerated() {
                                    
                var hash = keyWord.hash
                if hash < 0 { hash *= -1 }
                
                if hash % 1000 == id {
                    searchTable[keyWord] = allKeyWordManquant[keyWord]!
                }
                
                if ((i+1) % (allKeyWordManquant.count / 100)) == 0 {
                    DispatchQueue.main.async {
                        self.loadingStatus = .loadingPercent( "creating search table \(id) / \(nbrTableACree - 1)", ( (i + 1) / (allKeyWordManquant.count / 100) ) )
                    }
                }
            }
            
            let holder = SearchTableHolderMotJMdict(id: id, context: DataController.shared.privateQueueManagedObjectContext)
            holder.searchTable = searchTable
            
            DispatchQueue.main.async { self.loadingStatus = .loading("Saving") }

            try DataController.shared.privateQueueManagedObjectContext.save()
        }
    }
    
    
    
    private func breakString(_ str:String) -> Set<String> {
        
        var stringSet: Set<String> = []
        
        for i in 0..<str.count {
            
            let startIndex = str.index(str.startIndex, offsetBy: i)
            
            for y in i..<str.count {
                
                let endIndex = str.index(str.startIndex, offsetBy: y)
                        
                let subcript = str[startIndex...endIndex]
                
                stringSet.insert(String(subcript))
            }
        }
        
        return stringSet
    }

    private func getKeyWords(_ mot: Mot) -> Set<String> {
        
        var keyWordSet: Set<String> = []
        
        for japonai in mot.japonais ?? [] {
            if let kanji = japonai.kanji { keyWordSet.formUnion(breakString(kanji)) }
            if let kana = japonai.kana { keyWordSet.formUnion(breakString(kana)) }
        }
        
        for sense in mot.senses ?? [] {
            for trad in sense.traductionsArray ?? [] {
                if let traductions = trad.traductions { keyWordSet.formUnion(traductions) }
            }
        }
        
        for trad in mot.noSenseTradsArray ?? [] {
            if let traductions = trad.traductions { keyWordSet.formUnion(traductions) }
        }
        
        return keyWordSet
        
    }
}

struct DebugActionsView: View {
    @Environment(\.toggleSideMenu) var showSideMenu
    
    @StateObject private var vm = DebugActionsViewModel()

    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                switch vm.loadingStatus {
                    
                case .loading(let description):
                    HStack { Text("\(description) ") ; ProgressView() }
                
                case .loadingPercent(let description, let percent):
                    Text("\(description) - \(percent)%")
                    
                case .finished:
                    Text("Finished")
                }
                
                Spacer()
            }
            List {
                Button("Reimport JMdict") {
                    vm.showFileImporter.toggle()
                }
                
                Button("Recreate search tables") {
                    vm.reCreateSearchTables()
                }
                
                Button("Export sqlite Files") {
                    let sourceSqliteURLs = [
                        getApplicationSupportDirectory().appendingPathComponent("local.sqlite"),
                        getApplicationSupportDirectory().appendingPathComponent("local.sqlite-shm"),
                        getApplicationSupportDirectory().appendingPathComponent("local.sqlite-wal")
                    ]

                    let destSqliteURLs = [
                        getDocumentDirectory().appendingPathComponent("local.sqlite"),
                        getDocumentDirectory().appendingPathComponent("local.sqlite-shm"),
                        getDocumentDirectory().appendingPathComponent("local.sqlite-wal")
                    ]

                    for i in 0...2 {
                        try! FileManager.default.copyItem(at: sourceSqliteURLs[i], to: destSqliteURLs[i])
                    }
                }
                
                Toggle("Perform real search", isOn: Binding(get: { Settings.performRealSearch }, set: { Settings.performRealSearch = $0 }))
                
            }
        }
        .fileImporter(isPresented: $vm.showFileImporter, allowedContentTypes: [UTType("fileType.JMdictFile")!, .json],
                      onCompletion: vm.fileImporterCompletion)
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

struct DebugActionsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugActionsView()
    }
}
