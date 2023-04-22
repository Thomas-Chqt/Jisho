//
//  MetaData.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/27.
//
//

import Foundation
import CoreData

@objc(MetaData)
public class MetaData: Entity {
	
	//MARK: FetchRequests
	@nonobjc public class func fetchRequest() -> NSFetchRequest<MetaData> {
		return NSFetchRequest<MetaData>(entityName: "MetaData")
	}
	
	//MARK: NSManaged attributs
	@NSManaged private var traductions_atb: NSSet?
	
	
	//MARK: Computed variables
	var traductions: Set<Traduction> {
		get {
			guard let traductions_atb = traductions_atb else { return [] }
			guard let traductions = traductions_atb as? Set<Traduction> else { return [] }
			return traductions
		}
		set {
			if newValue.isEmpty { traductions_atb = nil ; return}
			traductions_atb = NSSet(set: newValue)
		}
	}
	
	var text: String? {
		get {
			return traductions.firstMatch()?.text
		}
		set {
			if let traduction = traductions.firstLangue() ?? addTraduction(Traduction(id: UUID(),
																						 langue: .first,
																						 context: self.objectContext)) {
				if let newValue = newValue {
					traduction.text = newValue
				}
				else {
					removeFromTraductions_atb(traduction)
				}
			}
			else {
				print("Error, no trad for selected langue and unable to create one")
				return
			}
		}
	}
	
	
	//MARK: Functions
	func addTraduction(_ traduction: Traduction) -> Traduction? {
		if !(traductions.contains { $0.langue == traduction.langue }) {
			addToTraductions_atb(traduction)
			return traduction
		}
		return nil
	}
	
	
	//MARK: inits
	convenience init(id: UUID? = nil, traductions: Set<Traduction>? = nil, context: NSManagedObjectContext? = nil) {
		self.init(id: id, context: context)

		self.traductions = traductions ?? []
	}
	
	convenience init(id: UUID? = nil, langue: Langue? = nil, text: String? = nil, context: NSManagedObjectContext? = nil) {
		self.init(id: id, context: context)
		
		if let langue = langue {
			self.traductions = [ Traduction(langue: langue, text: text, context: context) ]
		}
		else {
			self.text = text ?? ""
		}
	}
}


//MARK: Protocole extentions
extension MetaData: Displayable {
	var primary: String? {
		guard let text = text else { return nil }
		return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : text
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

// MARK: Generated accessors for traductions_atb
extension MetaData {
	
	@objc(addTraductions_atbObject:)
	@NSManaged public func addToTraductions_atb(_ value: Traduction)
	
	@objc(removeTraductions_atbObject:)
	@NSManaged public func removeFromTraductions_atb(_ value: Traduction)
	
	@objc(addTraductions_atb:)
	@NSManaged public func addToTraductions_atb(_ values: NSSet)
	
	@objc(removeTraductions_atb:)
	@NSManaged public func removeFromTraductions_atb(_ values: NSSet)
	
}
