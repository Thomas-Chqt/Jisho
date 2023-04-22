//
//  Exemple.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/05.
//
//

import Foundation
import CoreData

@objc(Exemple)
public class Exemple: Entity {
	
	//MARK: FetchRequests
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Exemple> {
		return NSFetchRequest<Exemple>(entityName: "Exemple")
	}
	
	//MARK: NSManaged attributs
	@NSManaged private var parent_atb: NSOrderedSet?
	@NSManaged private var japonais_atb: String?
	@NSManaged private var traductions_atb: NSSet?

	
	//MARK: Computed variables
	var japonais: String {
		get {
			return japonais_atb ?? ""
		}
		set {
			japonais_atb = newValue
		}
	}
	
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
	
	
	//MARK: Functions
	func addTraduction(_ traduction: Traduction) -> Traduction? {
		if !(traductions.contains { $0.langue == traduction.langue }) {
			addToTraductions_atb(traduction)
			return traduction
		}
		return nil
	}



	convenience init(id: UUID? = nil, japonais: String? = nil, traductions: Set<Traduction>? = nil, context: NSManagedObjectContext? = nil) {
		self.init(id: id, context: context)
		
		self.japonais = japonais ?? ""
		self.traductions = traductions ?? []
	}
	
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		let previewJaponais = ["私の名前はトーマスです", "私は猫が好き", "晴香が可愛い", "お前はバカだなぁ"]
		
		var previewTraductions: Set<Traduction> {
			let traductions:[Traduction] = [
				Traduction(id: UUID(), langue: .francais, text: "mon nom est thomas", context: context),
				Traduction(id: UUID(), langue: .francais, text: "J'aime les chats", context: context),
				Traduction(id: UUID(), langue: .francais, text: "Haruka est mignonne", context: context),
				Traduction(id: UUID(), langue: .francais, text: "Tu est con", context: context)
			]
			var output: Set<Traduction> = []
			for _ in 1...Int.random(in: 1...3) {
				output.insert(traductions.randomElement()!)
			}
			return output
		}
		
		switch type {
		case .empty:
			self.init(id: UUID(), context: context)
		case .preview:
			self.init(id: UUID(),
					  japonais: previewJaponais.randomElement()!,
					  traductions: previewTraductions,
					  context: context)
		}

	}
}

extension Exemple: Displayable {
	var primary: String? {
		return japonais
	}
	
	var secondary: String? {
		return traductions.first?.text
	}
}

extension Exemple: EasyInit {
	
}


// MARK: Generated accessors for parent_atb
extension Exemple {
	
	@objc(insertObject:inParent_atbAtIndex:)
	@NSManaged public func insertIntoParent_atb(_ value: Sense, at idx: Int)
	
	@objc(removeObjectFromParent_atbAtIndex:)
	@NSManaged public func removeFromParent_atb(at idx: Int)
	
	@objc(insertParent_atb:atIndexes:)
	@NSManaged public func insertIntoParent_atb(_ values: [Sense], at indexes: NSIndexSet)
	
	@objc(removeParent_atbAtIndexes:)
	@NSManaged public func removeFromParent_atb(at indexes: NSIndexSet)
	
	@objc(replaceObjectInParent_atbAtIndex:withObject:)
	@NSManaged public func replaceParent_atb(at idx: Int, with value: Sense)
	
	@objc(replaceParent_atbAtIndexes:withParent_atb:)
	@NSManaged public func replaceParent_atb(at indexes: NSIndexSet, with values: [Sense])
	
	@objc(addParent_atbObject:)
	@NSManaged public func addToParent_atb(_ value: Sense)
	
	@objc(removeParent_atbObject:)
	@NSManaged public func removeFromParent_atb(_ value: Sense)
	
	@objc(addParent_atb:)
	@NSManaged public func addToParent_atb(_ values: NSOrderedSet)
	
	@objc(removeParent_atb:)
	@NSManaged public func removeFromParent_atb(_ values: NSOrderedSet)
	
}

// MARK: Generated accessors for traductions_atb
extension Exemple {
	
	@objc(addTraductions_atbObject:)
	@NSManaged public func addToTraductions_atb(_ value: Traduction)
	
	@objc(removeTraductions_atbObject:)
	@NSManaged public func removeFromTraductions_atb(_ value: Traduction)
	
	@objc(addTraductions_atb:)
	@NSManaged public func addToTraductions_atb(_ values: NSSet)
	
	@objc(removeTraductions_atb:)
	@NSManaged public func removeFromTraductions_atb(_ values: NSSet)
	
}
