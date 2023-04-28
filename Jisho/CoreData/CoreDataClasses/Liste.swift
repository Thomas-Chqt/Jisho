//
//  Liste.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/28.
//
//

import Foundation
import CoreData

@objc(Liste)
public class Liste: Entity {
	
	//MARK: FetchRequests
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Liste> {
		return NSFetchRequest<Liste>(entityName: "Liste")
	}
	
	//MARK: NSManaged attributs
	@NSManaged private var name_atb: String?
	@NSManaged private var subListes_atb: NSOrderedSet?
	@NSManaged private var mots_atb: NSOrderedSet?
	@NSManaged private var parent_atb: Liste?
	
	
	//MARK: Computed variables
	var name: String {
		get { return name_atb ?? "Pas de nom" }
		set { name_atb = newValue }
	}
	
	var subListes: [Liste] {
		get {
			guard let subListes_atb = subListes_atb else { return [] }
			guard let subListes = subListes_atb.array as? [Liste] else { return [] }
			return subListes
		}
		set {
			if newValue.isEmpty { subListes_atb = nil ; return }
			subListes_atb = NSOrderedSet(array: newValue)
		}
	}
	
	var mots: [Mot] {
		get {
			guard let mots_atb = mots_atb else { return [] }
			guard let mots = mots_atb.array as? [Mot] else { return [] }
			return mots
		}
		set {
			if newValue.isEmpty { mots_atb = nil ; return }
			mots_atb = NSOrderedSet(array: newValue)
		}
	}
	
	
	//MARK: Functions
	func toggleMot(_ mot: Mot) {
		if self.mots.contains(mot) {
			self.removeFromMots_atb(mot)
		}
		else {
			self.mots.append(mot)
		}
	}
}




// MARK: Generated accessors for subListes_atb
extension Liste {

    @objc(insertObject:inSubListes_atbAtIndex:)
    @NSManaged public func insertIntoSubListes_atb(_ value: Liste, at idx: Int)

    @objc(removeObjectFromSubListes_atbAtIndex:)
    @NSManaged public func removeFromSubListes_atb(at idx: Int)

    @objc(insertSubListes_atb:atIndexes:)
    @NSManaged public func insertIntoSubListes_atb(_ values: [Liste], at indexes: NSIndexSet)

    @objc(removeSubListes_atbAtIndexes:)
    @NSManaged public func removeFromSubListes_atb(at indexes: NSIndexSet)

    @objc(replaceObjectInSubListes_atbAtIndex:withObject:)
    @NSManaged public func replaceSubListes_atb(at idx: Int, with value: Liste)

    @objc(replaceSubListes_atbAtIndexes:withSubListes_atb:)
    @NSManaged public func replaceSubListes_atb(at indexes: NSIndexSet, with values: [Liste])

    @objc(addSubListes_atbObject:)
    @NSManaged public func addToSubListes_atb(_ value: Liste)

    @objc(removeSubListes_atbObject:)
    @NSManaged public func removeFromSubListes_atb(_ value: Liste)

    @objc(addSubListes_atb:)
    @NSManaged public func addToSubListes_atb(_ values: NSOrderedSet)

    @objc(removeSubListes_atb:)
    @NSManaged public func removeFromSubListes_atb(_ values: NSOrderedSet)

}

// MARK: Generated accessors for mots_atb
extension Liste {

    @objc(insertObject:inMots_atbAtIndex:)
    @NSManaged public func insertIntoMots_atb(_ value: Mot, at idx: Int)

    @objc(removeObjectFromMots_atbAtIndex:)
    @NSManaged public func removeFromMots_atb(at idx: Int)

    @objc(insertMots_atb:atIndexes:)
    @NSManaged public func insertIntoMots_atb(_ values: [Mot], at indexes: NSIndexSet)

    @objc(removeMots_atbAtIndexes:)
    @NSManaged public func removeFromMots_atb(at indexes: NSIndexSet)

    @objc(replaceObjectInMots_atbAtIndex:withObject:)
    @NSManaged public func replaceMots_atb(at idx: Int, with value: Mot)

    @objc(replaceMots_atbAtIndexes:withMots_atb:)
    @NSManaged public func replaceMots_atb(at indexes: NSIndexSet, with values: [Mot])

    @objc(addMots_atbObject:)
    @NSManaged public func addToMots_atb(_ value: Mot)

    @objc(removeMots_atbObject:)
    @NSManaged public func removeFromMots_atb(_ value: Mot)

    @objc(addMots_atb:)
    @NSManaged public func addToMots_atb(_ values: NSOrderedSet)

    @objc(removeMots_atb:)
    @NSManaged public func removeFromMots_atb(_ values: NSOrderedSet)

}
