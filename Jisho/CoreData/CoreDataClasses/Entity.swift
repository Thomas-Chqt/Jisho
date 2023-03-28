//
//  Entity+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/27.
//
//

import Foundation
import CoreData

@objc(Entity)
public class Entity: NSManagedObject {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
		return NSFetchRequest<Entity>(entityName: "Entity")
	}
	
	@NSManaged public var id_atb: UUID?
	
	var ID: UUID {
		get {
			id_atb!
		}
		set {
			id_atb = newValue
		}
	}
}


extension Entity : Identifiable {
	
}
