//
//  MetaData+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/27.
//
//

import Foundation
import CoreData

@objc(MetaData)
public class MetaData: Entity {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<MetaData> {
		return NSFetchRequest<MetaData>(entityName: "MetaData")
	}
	
	@NSManaged public var text_atb: String?
	@NSManaged public var sensesIn_atb: NSOrderedSet?
	
	var text: String? {
		get {
			if text_atb == nil || text_atb == "" || text_atb == " " {
				return nil
			}
			return text_atb
		}
		set { text_atb = newValue }
	}
	
	
	private convenience init(ID: UUID? = nil, text: String? = nil, context: NSManagedObjectContext) {
		self.init(context: context)
		self.ID = ID ?? UUID()
		self.text = text
	}
	
	convenience init(struct metaDataStruct: MetaData_struct?, context: NSManagedObjectContext) {
		self.init(ID: metaDataStruct?.ID, text: metaDataStruct?.text, context: context)
	}
	
	convenience init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		self.init(struct: MetaData_struct(type), context: context ?? DataController.shared.mainQueueManagedObjectContext)
	}
}

// MARK: Generated accessors for sensesIn_atb
extension MetaData {
	
	@objc(insertObject:inSensesIn_atbAtIndex:)
	@NSManaged public func insertIntoSensesIn_atb(_ value: Sense, at idx: Int)
	
	@objc(removeObjectFromSensesIn_atbAtIndex:)
	@NSManaged public func removeFromSensesIn_atb(at idx: Int)
	
	@objc(insertSensesIn_atb:atIndexes:)
	@NSManaged public func insertIntoSensesIn_atb(_ values: [Sense], at indexes: NSIndexSet)
	
	@objc(removeSensesIn_atbAtIndexes:)
	@NSManaged public func removeFromSensesIn_atb(at indexes: NSIndexSet)
	
	@objc(replaceObjectInSensesIn_atbAtIndex:withObject:)
	@NSManaged public func replaceSensesIn_atb(at idx: Int, with value: Sense)
	
	@objc(replaceSensesIn_atbAtIndexes:withSensesIn_atb:)
	@NSManaged public func replaceSensesIn_atb(at indexes: NSIndexSet, with values: [Sense])
	
	@objc(addSensesIn_atbObject:)
	@NSManaged public func addToSensesIn_atb(_ value: Sense)
	
	@objc(removeSensesIn_atbObject:)
	@NSManaged public func removeFromSensesIn_atb(_ value: Sense)
	
	@objc(addSensesIn_atb:)
	@NSManaged public func addToSensesIn_atb(_ values: NSOrderedSet)
	
	@objc(removeSensesIn_atb:)
	@NSManaged public func removeFromSensesIn_atb(_ values: NSOrderedSet)
	
}
