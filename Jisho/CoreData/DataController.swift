//
//  DataController.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/22.
//

import Foundation
import CoreData


class DataController: ObservableObject
{
    static let shared = DataController()
    
    let container = NSPersistentCloudKitContainer(name: "DataModel")
    
    let mainQueueManagedObjectContext: NSManagedObjectContext
    let privateQueueManagedObjectContext: NSManagedObjectContext

//    @Published var loadingStatus:LoadingStatus? //= .finished
    
    private let searchTableHolderMotJMdictObjIDDict:[Int:NSManagedObjectID]
    
    private let motJMdictSearchTableCache = NSCache<NSNumber, NSDictionary>()
    
    init() {
//        let createSQLFiles = false
        
        // Create a store description for a local store
        let localStoreLocation = getApplicationSupportDirectory().appendingPathComponent("local.sqlite")
        
//        if createSQLFiles == false {
        if FileManager.default.fileExists(atPath: localStoreLocation.path) == false {
            
            let sourceSqliteURLs = [
                Bundle.main.url(forResource: "local", withExtension: "sqlite")!,
                Bundle.main.url(forResource: "local", withExtension: "sqlite-shm")!,
                Bundle.main.url(forResource: "local", withExtension: "sqlite-wal")!
            ]

            let destSqliteURLs = [
                getApplicationSupportDirectory().appendingPathComponent("local.sqlite"),
                getApplicationSupportDirectory().appendingPathComponent("local.sqlite-shm"),
                getApplicationSupportDirectory().appendingPathComponent("local.sqlite-wal")
            ]

            for i in 0...2 {
                try! FileManager.default.copyItem(at: sourceSqliteURLs[i], to: destSqliteURLs[i])
            }
        }
//        }
        
        let localStoreDescription = NSPersistentStoreDescription(url: localStoreLocation)
        localStoreDescription.configuration = "Local"
        
        
        // Create a store description for a CloudKit-backed local store
        let cloudStoreLocation = getApplicationSupportDirectory().appendingPathComponent("cloud.sqlite")
        let cloudStoreDescription = NSPersistentStoreDescription(url: cloudStoreLocation)
        cloudStoreDescription.configuration = "Cloud"

        // Set the container options on the cloud store
        cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.JishoSave")        
        
        // Update the container's list of store descriptions
        container.persistentStoreDescriptions = [ cloudStoreDescription, localStoreDescription ]

        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        
        mainQueueManagedObjectContext = container.viewContext
        
        mainQueueManagedObjectContext.automaticallyMergesChangesFromParent = true
        mainQueueManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        
        privateQueueManagedObjectContext = container.newBackgroundContext()
        
        privateQueueManagedObjectContext.automaticallyMergesChangesFromParent = true
        privateQueueManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
                
        /*
        if createSQLFiles {
            searchTableHolderMotJMdictObjIDDict = [:]
            
            Task {
                try await createSQLiteFiles()
                DispatchQueue.main.async { self.loadingStatus = .finished }
            }
        }
        
        
        else {
          */
            var TEMPsearchTableHolderMotJMdictObjIDDict:[Int:NSManagedObjectID] = [:]
            
            for i in 0...999 {
                
                let request:NSFetchRequest<NSManagedObjectID> = SearchTableHolderMotJMdict.fetchRequest()
                request.predicate = NSPredicate(format: "idAtb == %i", i)
                let result = try! mainQueueManagedObjectContext.fetch(request)
                guard let holderIObjID = result.first else { fatalError() }
                TEMPsearchTableHolderMotJMdictObjIDDict[i] = holderIObjID
            }
            
            self.searchTableHolderMotJMdictObjIDDict = TEMPsearchTableHolderMotJMdictObjIDDict
            
//            self.loadingStatus = .finished
            
//        }
        
    }
    
    
    func getSearchtableMotJMdict(id: Int) -> [String:Set<NSManagedObjectID>] {
        
        if let cachedVersion = motJMdictSearchTableCache.object(forKey: NSNumber(value: id)) {
            
            return cachedVersion as! Dictionary<String,Set<NSManagedObjectID>>
        }
        
        let searchTable = (self.privateQueueManagedObjectContext.object(with: self.searchTableHolderMotJMdictObjIDDict[id]! ) as! SearchTableHolderMotJMdict).searchTable
        
        motJMdictSearchTableCache.setObject(searchTable as NSDictionary, forKey: NSNumber(value: id))
        return searchTable
    }
        
    
    func save() async throws {
        
        try await mainQueueManagedObjectContext.perform { //[weak self] in
            
//            guard let self = self else { fatalError() }
            
            if self.mainQueueManagedObjectContext.hasChanges {
                try self.mainQueueManagedObjectContext.save()
            }
        }
        
        try await privateQueueManagedObjectContext.perform { //[weak self] in
            
//            guard let self = self else { fatalError() }
            
            if self.privateQueueManagedObjectContext.hasChanges {
                try self.privateQueueManagedObjectContext.save()
            }
        }
    }
    
            
    /*
    func createSQLiteFiles() async throws {
        

        try await loadJMdict()
        
        guard let searchTablesIDsManquantes = try await getSearchTablesIDsManquantes() else { return }
        
        let allKeyWordManquant = try await getAllKeyWordManquant(tableManquantesIDs: searchTablesIDsManquantes)
        
        for id in searchTablesIDsManquantes.sorted() {
            try await createSearcheTable(allKeyWordManquant: allKeyWordManquant, id: id, nbrTableACree: searchTablesIDsManquantes.count)
        }
                
        
        func loadJMdict() async throws {
            
            try await privateQueueManagedObjectContext.perform { 
                
                DispatchQueue.main.async { self.loadingStatus = .loading }
                
                let request:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest()
                let nombreMotJMdict = try self.privateQueueManagedObjectContext.count(for: request)
                
                if nombreMotJMdict > 0 { return }
                
                let jmDictXcodeURL = Bundle.main.url(forResource: "JMdict", withExtension: "json")!
                let parsedJMDict = try parsJMdict(file: jmDictXcodeURL)
                
                DispatchQueue.main.async { self.loadingStatus = .loadingPercent("Importing JMdict", 0) }
                
                for (i, mot) in parsedJMDict.enumerated() {
                    
                    _ = MotJMdict(ordre: Int64(i), strct: mot, context: self.privateQueueManagedObjectContext)
                    
                    if ((i+1) % (parsedJMDict.count / 100)) == 0 {
                        DispatchQueue.main.async { self.loadingStatus = .loadingPercent("Importing JMdict", ((i + 1) / (parsedJMDict.count / 100))) }
                    }
                }
                
                DispatchQueue.main.async { self.loadingStatus = .loading }
                
                try self.privateQueueManagedObjectContext.save()
            }

            
        }
        
        func getSearchTablesIDsManquantes() async throws -> Set<Int>? {
            
            try await privateQueueManagedObjectContext.perform {
                let request:NSFetchRequest<SearchTableHolderMotJMdict> = SearchTableHolderMotJMdict.fetchRequest()
                let existingSearchTablesIDs = (try self.privateQueueManagedObjectContext.fetch(request)).map { Int($0.idAtb) }
                
                var nonExisting = Array(0...999)
                nonExisting.removeAll(where: { existingSearchTablesIDs.contains($0) })
                
                return nonExisting.isEmpty ? nil : Set(nonExisting)
            }

        }
        
        func getAllKeyWordManquant(tableManquantesIDs: Set<Int>) async throws -> [String:Set<NSManagedObjectID>] {
            
            try await privateQueueManagedObjectContext.perform {
                
                DispatchQueue.main.async { self.loadingStatus = .loading }

                let request:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest()
                let allMotJMdict = try self.privateQueueManagedObjectContext.fetch(request)
                                    
                try self.privateQueueManagedObjectContext.obtainPermanentIDs(for: allMotJMdict)
                
                var searchTable:[String:Set<NSManagedObjectID>] = [:]
                
                DispatchQueue.main.async { self.loadingStatus = .loadingPercent("Getting all keyWords", 0) }
                
                for (i, mot) in allMotJMdict.enumerated() {
                    
                    for keyWord in getKeyWords(mot) {
                                            
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
        
        func createSearcheTable( allKeyWordManquant: [String:Set<NSManagedObjectID>], id:Int, nbrTableACree: Int) async throws {
            
            try await self.privateQueueManagedObjectContext.perform {
                
                var searchTable:[String:Set<NSManagedObjectID>] = [:]
                
                DispatchQueue.main.async { self.loadingStatus = .loadingPercent( "creating search table (\(id)) / \(nbrTableACree - 1)", 0 ) }

                for (i, keyWord) in allKeyWordManquant.keys.enumerated() {
                                        
                    var hash = keyWord.hash
                    if hash < 0 { hash *= -1 }
                    
                    if hash % 1000 == id {
                        searchTable[keyWord] = allKeyWordManquant[keyWord]!
                    }
                    
                    if ((i+1) % (allKeyWordManquant.count / 100)) == 0 {
                        DispatchQueue.main.async {
                            self.loadingStatus = .loadingPercent( "creating search table (\(id)) / \(nbrTableACree - 1))", ( (i + 1) / (allKeyWordManquant.count / 100) ) )
                        }
                    }
                }
                
                let holder = SearchTableHolderMotJMdict(id: id, context: self.privateQueueManagedObjectContext)
                holder.searchTable = searchTable

                DispatchQueue.main.async { self.loadingStatus = .loading }

                try self.privateQueueManagedObjectContext.save()
            }
        }
    }
    */
      
}
