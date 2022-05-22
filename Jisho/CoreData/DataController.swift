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
        
    
    init() {
        
        // Create a store description for a local store
        let localStoreLocation = getApplicationSupportDirectory().appendingPathComponent("local.sqlite")
        
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
}
