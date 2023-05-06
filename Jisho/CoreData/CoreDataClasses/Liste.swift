//
//  Liste.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/28.
//
//

import Foundation
import CoreData
import SwiftUI
import UniformTypeIdentifiers

@objc(Liste)
public class Liste: Entity {
	
	//MARK: FetchRequests
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Liste> {
		return NSFetchRequest<Liste>(entityName: "Liste")
	}
	
	@nonobjc public class func rootListesFetchRequest() -> NSFetchRequest<Liste> {
		let request:NSFetchRequest<Liste> = self.fetchRequest()
		request.predicate = NSPredicate(format: "parent_atb == nil")
		request.sortDescriptors = [ NSSortDescriptor(key: "order_atb", ascending: true) ]
		return request
	}
	
	@nonobjc public class func allListesFetchRequest() -> NSFetchRequest<Liste> {
		let request:NSFetchRequest<Liste> = self.fetchRequest()
		request.sortDescriptors = [ NSSortDescriptor(key: "editTime_atb", ascending: false) ]
		return request
	}

	
	
	//MARK: NSManaged attributs
	@NSManaged private var name_atb: String?
	@NSManaged private var subListes_atb: NSOrderedSet?
	@NSManaged private var mots_atb: NSOrderedSet?
	@NSManaged private var parent_atb: Liste?
	@NSManaged private var order_atb: Int32
	
	
	//MARK: Computed variables
	var name: String {
		get { return name_atb ?? "Pas de nom" }
		set {
			name_atb = newValue
			editTime = Date()
		}
	}
	
	var parent: Liste? {
		get {
			parent_atb
		}
		set {
			parent_atb = newValue
			editTime = Date()
		}
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
			editTime = Date()
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
			editTime = Date()
		}
	}
	
	var order: Int? {
		get {
			if order_atb >= 0 {
				return Int(order_atb)
			}
			else {
				return nil
			}
		}
		set {
			if let newValue = newValue {
				if newValue >= 0 {
					order_atb = Int32(newValue)
					return
				}
			}
			order_atb = -1
		}
	}
	
	
	//MARK: Functions
	func contains(_ mot: Mot) -> Bool {
		return self.mots.contains(where: { $0.id == mot.id })
	}
	
	func toggleMot(_ mot: Mot) {
		if self.contains(mot) {
			self.removeFromMots_atb(mot)
		}
		else {
			self.mots.append(mot)
		}
	}
	
	func removeFromParent() -> Liste {
		self.parent = nil
		return self
	}
	
	
	//MARK: inits
	convenience init(id: UUID? = nil,
					 name: String? = nil,
					 subListes: [Liste]? = nil,
					 mots: [Mot]? = nil,
					 order: Int? = nil,
					 context: NSManagedObjectContext? = nil) {
		self.init(id: id, context: context)
		
		
		self.name = name ?? ""
		self.subListes = subListes ?? []
		self.mots = mots ?? []
		self.order = order
	}
	
	//MARK: EasyInit's init
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		
		let previewName = ["Liste A", "Liste Test", "Liste"]
		
		switch type {
		case .empty:
			self.init(id: nil, name: nil, context: context)
		case .preview:
			self.init(id: nil,
					  name: previewName.randomElement()!,
					  context: context)
		}
	}

}

//MARK: Protocole extentions
extension Liste: Displayable {
	var primary: String? {
		name
	}
}

extension Liste: EasyInit { }

extension Liste: Transferable {
	static public var transferRepresentation: some TransferRepresentation {
		DataRepresentation(contentType: .liste) { entity in
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

extension Liste: NSItemProviderWriting {
	public static var writableTypeIdentifiersForItemProvider: [String] {
		return [ UTType.liste.identifier ]
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


//MARK: Array extentions
extension [Liste] {
	mutating func moveIn(_ liste: Liste) {
		self.append(liste.removeFromParent())
	}
	
	mutating func moveIn(_ liste: Liste, at index: Int) {
		self.insert(liste.removeFromParent(), at: index)
	}
	
	mutating func moveIn(_ listes: [Liste]) {
		for liste in listes {
			self.moveIn(liste)
		}
	}
	
	mutating func moveIn(_ listes: [Liste], _ position: CGPoint) -> Bool {
		self.moveIn(listes)
		return true
	}
	
	mutating func moveIn(_ listes: [Liste], at index: Int) {
		var index = index
		for liste in listes {
			self.insert(liste.removeFromParent(), at: index)
			index += 1
		}
	}
	
	mutating func moveIn(_ listes: [Liste], at index: Int? = nil) {
		if let index = index {
			self.moveIn(listes, at: index)
		}
		else {
			self.moveIn(listes)
		}
	}
}


//MARK: Other extentions
extension Liste {
	func moveIn(_ liste: Liste) {
		if liste.isLooping(ifInsertIn: self) { return }
		self.subListes.moveIn(liste)
	}
	
	func moveIn(_ listes: [Liste]) {
		self.subListes.moveIn(listes.filter{ $0.isLooping(ifInsertIn: self) == false })
	}
	
	func moveIn(_ liste: Liste, at index: Int) {
		if liste.isLooping(ifInsertIn: self) { return }
		self.subListes.moveIn(liste, at: index)
	}
	
	func moveIn(_ listes: [Liste], at index: Int) {
		self.subListes.moveIn(listes.filter{ $0.isLooping(ifInsertIn: self) == false }, at: index)
	}
	
	func moveIn(_ listes: [Liste], at index: Int? = nil) {
		if let index = index {
			self.moveIn(listes, at: index)
		}
		else {
			self.moveIn(listes)
		}
	}
}

extension Liste {
	func isLooping(ifInsertIn liste: Liste) -> Bool {
		if self.id == liste.id { return true }
		var parent = liste.parent
		while let unWrappParent = parent {
			if self.id == unWrappParent.id { return true }
			parent = unWrappParent.parent
		}
		return false
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
