//
//  Entity.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/27.
//
//

import Foundation
import CoreData
import SwiftUI
import UniformTypeIdentifiers

@objc(Entity)
public class Entity: NSManagedObject, Identifiable {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
		return NSFetchRequest<Entity>(entityName: "Entity")
	}
	
	@NSManaged private var id_atb: UUID?
	@NSManaged private var createTime_atb: Date?
	@NSManaged private var editTime_atb: Date?
	
	public var id: UUID {
		get {
			guard let id_atb = id_atb else {
				print("nil ID, return random uuid")
				return UUID()
//				fatalError("nil id")
			}
			return id_atb
		}
		set {
			id_atb = newValue
		}
	}
	
	public var createTime: Date {
		get {
			return createTime_atb!
		}
		set {
			createTime_atb = newValue
		}
	}
	
	public var editTime: Date {
		get {
			return editTime_atb!
		}
		set {
			editTime_atb = newValue
		}
	}
	
	public var objectContext: NSManagedObjectContext {
		guard let context = self.managedObjectContext else { fatalError("Entity not in any context") }
		return context
	}
		
	
	//MARK: Functions
	func delete() {
		self.objectContext.delete(self)
	}
	
	
	//MARK: inits
	convenience init(id: UUID? = nil, context: NSManagedObjectContext? = nil) {
		self.init(context: context ?? DataController.shared.mainQueueManagedObjectContext)

		self.id = id ?? UUID()
		let date = Date()
		createTime = date
		editTime = date
	}
	
}

/*
//MARK: Protocole extentions
extension Entity: Transferable {
	static public var transferRepresentation: some TransferRepresentation {
		DataRepresentation(contentType: .entity) { entity in
			let context = DataController.shared.privateQueueManagedObjectContext
			if entity.objectID.isTemporaryID {
				try await context.perform {
					try context.obtainPermanentIDs(for: [entity])
				}
			}
			let URI = entity.objectID.uriRepresentation()
			return try JSONEncoder().encode(URI)
			
		} importing: { data in
			let URI = try JSONDecoder().decode(URL.self, from: data)
			let context = DataController.shared.mainQueueManagedObjectContext
			guard let persistentStoreCoordinator = context.persistentStoreCoordinator else { throw DataRepError.NilPersStoreCoor }
			guard let ObjID = persistentStoreCoordinator.managedObjectID(forURIRepresentation: URI) else { throw DataRepError.ObjIDNotFound }
			
			return try await context.perform {
				guard let entity = context.object(with: ObjID) as? Self else { throw DataRepError.ObjNotFound }
				return entity
			}
		}

	}
}

extension Entity: NSItemProviderWriting {
	public static var writableTypeIdentifiersForItemProvider: [String] {
		return [ UTType.entity.identifier ]
	}
	
	public func loadData(withTypeIdentifier typeIdentifier: String,
						 forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void) -> Progress? {
		let progress = Progress(totalUnitCount: 100)
		do {
			let context = DataController.shared.privateQueueManagedObjectContext
			if self.objectID.isTemporaryID {
				context.perform {
					do {
						try context.obtainPermanentIDs(for: [self])
					}
					catch {
						completionHandler(nil, error)
					}
				}
			}
			let URI = self.objectID.uriRepresentation()
			let data = try JSONEncoder().encode(URI)
			completionHandler(data, nil)
		}
		catch {
			completionHandler(nil, error)
		}
		return progress
	}
	
	
}
*/
