//
//  MetaData.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/27.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(MetaData)
public class MetaData: Entity {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<MetaData> {
		return NSFetchRequest<MetaData>(entityName: "MetaData")
	}
	
	@NSManaged public var sensesIn_atb: NSOrderedSet?
	@NSManaged public var traductions_atb: NSSet?
	
	var traductions: Set<Traduction>? {
		get {
			guard let traductions_atb = traductions_atb else { return nil }
			guard let traductions = traductions_atb as? Set<Traduction> else { return nil }
			return traductions.isEmpty ? nil : traductions
		}
		set {
			guard let newValue = newValue else { traductions_atb = nil ; return}
			if newValue.isEmpty { traductions_atb = nil ; return}
			traductions_atb = NSSet(set: newValue)
		}
	}
	
	var text: String? {
		get {
			return traductions?.firstMatch()?.text
		}
		set {
//			if newValue?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true { return }
			self.objectWillChange.send()
			guard let traduction = traductions?.firstLangue() ??
									addTraduction(Traduction(id: UUID(), langue: .first, context: self.objectContext)) else {
				print("Error, no trad for selected langue and unable to create one")
				return
			}
			traduction.text = newValue
		}
	}
	
	var bindingText: Binding<String> {
		return Binding( get: { self.text ?? ""},
						set: { self.text = $0 })
	}
	
	func addTraduction(_ traduction: Traduction) -> Traduction? {
		guard let traductions = self.traductions else {
			addToTraductions_atb(traduction)
			return traduction
		}
		
		if !(traductions.contains { $0.langue == traduction.langue }) {
			addToTraductions_atb(traduction)
			return traduction
		}
		return nil
	}
	
	convenience init(id: UUID, traductions: Set<Traduction>? = nil, context: NSManagedObjectContext) {
		self.init(id: id, context: context)

		self.traductions = traductions
	}
	
	convenience init(id: UUID, text: String? = nil, context: NSManagedObjectContext) {
		self.init(id: id, context: context)
		
		self.text = text
	}

	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		let previewTexts = ["Nom commun", "Verbe", "Adjectif", "Nom propre"]
		
		let context:NSManagedObjectContext = context ?? DataController.shared.mainQueueManagedObjectContext
		
		switch type {
		case .empty:
			self.init(id: UUID(), context: context)
		case .preview:
			self.init(id: UUID(),
					  text: previewTexts.randomElement()!,
					  context: context)
		}
	}
	
	convenience init(jsonMetaData: json_MetaData, context: NSManagedObjectContext) {
		self.init(id: UUID(),
				  traductions: [Traduction(id: UUID(), langue: .francais,
										   text: jsonMetaData.fr, context: context),
								Traduction(id: UUID(), langue: .anglais,
										   text: jsonMetaData.en, context: context)],
				  context: context)
	}
}

extension MetaData: Displayable {
	var primary: String? {
		return text
	}
}

extension MetaData: EasyInit {
}

extension MetaData?: Identifiable {
	public var id: UUID? {
		return self?.id
	}
}

extension MetaData {
	static let cache = NSCache<NSString, MetaData>()
}

extension Array where Element == MetaData {
	func filtered(by filter: String) -> [MetaData] {
		return self.filter { metaData in
			if filter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return true }
			return metaData.text?.localizedStandardContains(filter) ?? false
		}
	}
}

extension FetchedResults where Result == MetaData {
	func filtered(by filter: String) -> [MetaData] {
		return self.map { $0 }.filtered(by: filter)
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
