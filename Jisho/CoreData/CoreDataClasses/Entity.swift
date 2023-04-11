//
//  Entity.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/27.
//
//

import Foundation
import CoreData

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
			guard let id_atb = id_atb else { fatalError("nil id") }
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
	
	public var objectContext: NSManagedObjectContext {
		guard let context = self.managedObjectContext else { fatalError("Entity not in any context") }
		return context
	}
	
	func delete() {
		self.objectContext.delete(self)
	}
	
	convenience init(id: UUID, context: NSManagedObjectContext) {
		self.init(context: context)
		
		self.id = id
		createTime = Date()
	}
	
}
