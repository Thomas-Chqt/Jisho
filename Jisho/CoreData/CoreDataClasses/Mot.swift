//
//  Mot.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/28.
//
//

import Foundation
import CoreData

@objc(Mot)
public class Mot: Entity {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Mot> {
		return NSFetchRequest<Mot>(entityName: "Mot")
	}
	
	@NSManaged private var jmDictID_atb: Int32
	
	@NSManaged private var japonais_atb: NSOrderedSet?
	@NSManaged private var sense_atb: NSOrderedSet?
	@NSManaged public var noSenseTrads_atb: NSSet?

	
	@NSManaged private var notes_atb: String?
	
	
	var jmDictId: Int? {
		get {
			if jmDictID_atb > 0 {
				return Int(jmDictID_atb)
			}
			else {
				return nil
			}
		}
		set {
			if let newValue = newValue {
				if newValue > 0 {
					jmDictID_atb = Int32(newValue)
					return
				}
			}
			jmDictID_atb = -1
		}
	}
	
	var japonais: [Japonais]? {
		get {
			guard let japonais_atb = japonais_atb else { return nil }
			let jap = japonais_atb.array as! [Japonais]
			if jap.isEmpty { return nil }
			return jap
		}
		set {
			guard let newValue = newValue else { japonais_atb = nil ; return}
			if newValue.isEmpty { japonais_atb = nil ; return}
			japonais_atb = NSOrderedSet(array: newValue)
		}
	}
	
	var senses: [Sense]? {
		get {
			guard let sense_atb = sense_atb else { return nil }
			let senses = sense_atb.array as! [Sense]
			if senses.isEmpty { return nil }
			return senses
		}
		set {
			guard let newValue = newValue else { sense_atb = nil ; return}
			if newValue.isEmpty { sense_atb = nil ; return}
			sense_atb = NSOrderedSet(array: newValue)
		}
	}
	
	var notes: String? {
		get {
			guard let notes_atb = notes_atb else { return nil }
			if notes_atb.trimmingCharacters(in: .whitespaces).isEmpty { return nil }
			return notes_atb
		}
		set {
			guard let newValue = newValue else { notes_atb = nil ; return }
			if newValue.trimmingCharacters(in: .whitespaces).isEmpty { notes_atb = nil ; return }
			notes_atb = newValue
		}
	}
	
	convenience init(id: UUID,
					 jmDictId: Int? = nil,
					 japonais: [Japonais]? = nil,
					 sense: [Sense]? = nil,
					 notes: String? = nil,
					 context: NSManagedObjectContext) {
		self.init(id: id, context: context)
		
		self.jmDictId = jmDictId
		self.japonais = japonais
		self.senses = sense
		self.notes = notes
	}
	
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		let context:NSManagedObjectContext = context ?? DataController.shared.mainQueueManagedObjectContext

		let previewJmdictID = [10000, 13404, 53794, 31908, 45478, 64358, nil]
		let previewNotes = ["Pas de notes", "Note test 1", "Hello world", "Yolo yolo", nil]
		
		var previewJaponais: [Japonais]? {
			var japonais: [Japonais] = []
			for _ in 1...Int.random(in: 1...4) {
				japonais.append(Japonais(.preview, context: context))
			}
			return japonais
		}
		
		var previewSenses: [Sense]? {
			var senses: [Sense] = []
			for _ in 1...Int.random(in: 1...4) {
				senses.append(Sense(.preview, context: context))
			}
			return senses
		}
		
		switch type {
		case .empty:
			self.init(id: UUID(), context: context)
		case .preview:
			self.init(id: UUID(),
					  jmDictId: previewJmdictID.randomElement()!,
					  japonais: previewJaponais,
					  sense: previewSenses,
					  notes: previewNotes.randomElement()!,
					  context: context)
		}
	}
}

extension Mot: Displayable {
	var primary: String? {
		return japonais?.first?.kanjis?.first
	}
	var secondary: String? {
		return japonais?.first?.kanas?.first
	}
	var details: String? {
		return senses?.first?.traductions?.firstMatch()?.text
	}
}

extension Mot: EasyInit {
	
}

// MARK: Generated accessors for japonais_atb
extension Mot {
	
	@objc(insertObject:inJaponais_atbAtIndex:)
	@NSManaged public func insertIntoJaponais_atb(_ value: Japonais, at idx: Int)
	
	@objc(removeObjectFromJaponais_atbAtIndex:)
	@NSManaged public func removeFromJaponais_atb(at idx: Int)
	
	@objc(insertJaponais_atb:atIndexes:)
	@NSManaged public func insertIntoJaponais_atb(_ values: [Japonais], at indexes: NSIndexSet)
	
	@objc(removeJaponais_atbAtIndexes:)
	@NSManaged public func removeFromJaponais_atb(at indexes: NSIndexSet)
	
	@objc(replaceObjectInJaponais_atbAtIndex:withObject:)
	@NSManaged public func replaceJaponais_atb(at idx: Int, with value: Japonais)
	
	@objc(replaceJaponais_atbAtIndexes:withJaponais_atb:)
	@NSManaged public func replaceJaponais_atb(at indexes: NSIndexSet, with values: [Japonais])
	
	@objc(addJaponais_atbObject:)
	@NSManaged public func addToJaponais_atb(_ value: Japonais)
	
	@objc(removeJaponais_atbObject:)
	@NSManaged public func removeFromJaponais_atb(_ value: Japonais)
	
	@objc(addJaponais_atb:)
	@NSManaged public func addToJaponais_atb(_ values: NSOrderedSet)
	
	@objc(removeJaponais_atb:)
	@NSManaged public func removeFromJaponais_atb(_ values: NSOrderedSet)
	
}

// MARK: Generated accessors for noSenseTrads_atb
extension Mot {
	
	@objc(addTraductions_atbObject:)
	@NSManaged public func addToNoSenseTrads_atb(_ value: Traduction)
	
	@objc(removeTraductions_atbObject:)
	@NSManaged public func removeFromNoSenseTrads_atb(_ value: Traduction)
	
	@objc(addTraductions_atb:)
	@NSManaged public func addToNoSenseTrads_atb(_ values: NSSet)
	
	@objc(removeTraductions_atb:)
	@NSManaged public func removeFromNoSenseTrads_atbb(_ values: NSSet)
	
}

// MARK: Generated accessors for sense_atb
extension Mot {
	
	@objc(insertObject:inSense_atbAtIndex:)
	@NSManaged public func insertIntoSense_atb(_ value: Sense, at idx: Int)
	
	@objc(removeObjectFromSense_atbAtIndex:)
	@NSManaged public func removeFromSense_atb(at idx: Int)
	
	@objc(insertSense_atb:atIndexes:)
	@NSManaged public func insertIntoSense_atb(_ values: [Sense], at indexes: NSIndexSet)
	
	@objc(removeSense_atbAtIndexes:)
	@NSManaged public func removeFromSense_atb(at indexes: NSIndexSet)
	
	@objc(replaceObjectInSense_atbAtIndex:withObject:)
	@NSManaged public func replaceSense_atb(at idx: Int, with value: Sense)
	
	@objc(replaceSense_atbAtIndexes:withSense_atb:)
	@NSManaged public func replaceSense_atb(at indexes: NSIndexSet, with values: [Sense])
	
	@objc(addSense_atbObject:)
	@NSManaged public func addToSense_atb(_ value: Sense)
	
	@objc(removeSense_atbObject:)
	@NSManaged public func removeFromSense_atb(_ value: Sense)
	
	@objc(addSense_atb:)
	@NSManaged public func addToSense_atb(_ values: NSOrderedSet)
	
	@objc(removeSense_atb:)
	@NSManaged public func removeFromSense_atb(_ values: NSOrderedSet)
	
}
