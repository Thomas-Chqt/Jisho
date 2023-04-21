//
//  DataController.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/21.
//

import Foundation
import CoreData

class DataController: ObservableObject {
	
	static let shared = DataController()
	
	static let localStoreLocationSQLite = applicationSupportDirectory.appendingPathComponent("local.sqlite")
	static let localStoreLocationSQLiteSHM = applicationSupportDirectory.appendingPathComponent("local.sqlite-shm")
	static let localStoreLocationSQLiteWAL = applicationSupportDirectory.appendingPathComponent("local.sqlite-wal")
	
//	static let cloudStoreLocationSQLite = applicationSupportDirectory.appendingPathComponent("cloud.sqlite")
//	static let cloudStoreLocationSQLiteSHM = applicationSupportDirectory.appendingPathComponent("cloud.sqlite-shm")
//	static let cloudStoreLocationSQLiteWAL = applicationSupportDirectory.appendingPathComponent("cloud.sqlite-wal")

	
//	let container = NSPersistentCloudKitContainer(name: "DataModel")
	let container = NSPersistentContainer(name: "DataModel")
	
	let mainQueueManagedObjectContext: NSManagedObjectContext
	let privateQueueManagedObjectContext: NSManagedObjectContext
	
	init() {
		
//		if FileManager.default.fileExists(atPath: DataController.localStoreLocationSQLite.path) == false {
//			let sourceSqliteURLs = [
//				Bundle.main.url(forResource: "local", withExtension: "sqlite")!,
//				Bundle.main.url(forResource: "local", withExtension: "sqlite-shm")!,
//				Bundle.main.url(forResource: "local", withExtension: "sqlite-wal")!
//			]
//
//			let destSqliteURLs = [
//				DataController.localStoreLocationSQLite,
//				DataController.localStoreLocationSQLiteSHM,
//				DataController.localStoreLocationSQLiteWAL
//			]
//
//			for i in 0...2 {
//				try! FileManager.default.copyItem(at: sourceSqliteURLs[i], to: destSqliteURLs[i])
//			}
//		}
		
		let localStoreDescription = NSPersistentStoreDescription(url: DataController.localStoreLocationSQLite)
//		localStoreDescription.configuration = "Local"
		
//		let cloudStoreDescription = NSPersistentStoreDescription(url: DataController.cloudStoreLocationSQLite)
//		cloudStoreDescription.configuration = "Cloud"
		
//		cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.JishoV2")
		
		container.persistentStoreDescriptions = [ localStoreDescription/*, cloudStoreDescription*/ ]
		
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
	
	
	
	func save() {
		Task {
			do {
				try await mainQueueManagedObjectContext.perform {
					if self.mainQueueManagedObjectContext.hasChanges {
						try self.mainQueueManagedObjectContext.save()
					}
				}
				
				try await privateQueueManagedObjectContext.perform {
					if self.privateQueueManagedObjectContext.hasChanges {
						try self.privateQueueManagedObjectContext.save()
					}
				}
			}
			catch {
				fatalError(error.localizedDescription)
			}
		}
	}
	
	func save() async throws {
		try await mainQueueManagedObjectContext.perform {
			if self.mainQueueManagedObjectContext.hasChanges {
				try self.mainQueueManagedObjectContext.save()
			}
		}
		
		try await privateQueueManagedObjectContext.perform {
			if self.privateQueueManagedObjectContext.hasChanges {
				try self.privateQueueManagedObjectContext.save()
			}
		}
	}
	
}

var applicationSupportDirectory: URL {
	let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
	let documentsDirectory = paths[0]
	return documentsDirectory
}
