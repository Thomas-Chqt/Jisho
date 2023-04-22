//
//  Sense.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/04.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Sense)
public class Sense: Entity {
	
	//MARK: FetchRequests
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Sense> {
		return NSFetchRequest<Sense>(entityName: "Sense")
	}
	
	
	//MARK: NSManaged attributs
	@NSManaged private var communMetaDatas_atb: NSOrderedSet?
	@NSManaged private var uniqueMetaDatas_atb: NSOrderedSet?
	@NSManaged private var linkMetaData_atb: NSOrderedSet?
	
	@NSManaged private var traductions_atb: NSSet?

	@NSManaged private var exemples_atb: NSOrderedSet?

	@NSManaged private var backLink_atb: NSSet?
	@NSManaged private var parent_atb: Mot?
	
	
	//MARK: Computed variables
	var communMetaDatas: [CommunMetaData] {
		get {
			guard let communMetaDatas_atb = communMetaDatas_atb else { return [] }
			guard let communMetaDatas = communMetaDatas_atb.array as? [CommunMetaData] else { return [] }
			return communMetaDatas
		}
		set {
			if newValue.isEmpty { communMetaDatas_atb = nil ; return }
			communMetaDatas_atb = NSOrderedSet(array: newValue)
		}
	}
	
	var uniqueMetaDatas: [UniqueMetaData] {
		get {
			guard let uniqueMetaDatas_atb = uniqueMetaDatas_atb else { return [] }
			guard let uniqueMetaDatas = uniqueMetaDatas_atb.array as? [UniqueMetaData] else { return [] }
			return uniqueMetaDatas
		}
		set {
			if newValue.isEmpty { uniqueMetaDatas_atb = nil ; return }
			uniqueMetaDatas_atb = NSOrderedSet(array: newValue)
		}
	}
	
	var linkMetaData: [LinkMetaData] {
		get {
			guard let linkMetaData_atb = linkMetaData_atb else { return [] }
			guard let linkMetaData = linkMetaData_atb.array as? [LinkMetaData] else { return [] }
			return linkMetaData
		}
		set {
			if newValue.isEmpty { linkMetaData_atb = nil ; return }
			linkMetaData_atb = NSOrderedSet(array: newValue)
		}
	}
	
	var metaDatas: [MetaData] {
		get {
			return self.communMetaDatas + self.uniqueMetaDatas + self.linkMetaData
		}
		set {
			self.communMetaDatas = newValue.compactMap { $0 as? CommunMetaData }
			self.uniqueMetaDatas = newValue.compactMap { $0 as? UniqueMetaData }
			self.linkMetaData 	 = newValue.compactMap { $0 as? LinkMetaData }
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
	
	var exemples: [Exemple] {
		get {
			guard let exemples_atb = exemples_atb else { return [] }
			guard let exemples = exemples_atb.array as? [Exemple] else { return [] }
			return exemples
		}
		set {
			if newValue.isEmpty { exemples_atb = nil ; return}
			exemples_atb = NSOrderedSet(array: newValue)
		}
	}
	
	
	//MARK: Functions
	func removeCommunMetaData(_ metaData: CommunMetaData) {
		self.removeFromCommunMetaDatas_atb(metaData)
	}
	
	func addTraduction(_ traduction: Traduction) -> Traduction? {
		if !(traductions.contains { $0.langue == traduction.langue }) {
			addToTraductions_atb(traduction)
			return traduction
		}
		return nil
	}
	

	//MARK: inits
	convenience init(id: UUID? = nil,
					 metaDatas: [MetaData]? = nil,
					 traductions: Set<Traduction>? = nil,
					 exemples: [Exemple]? = nil,
					 context: NSManagedObjectContext? = nil) {
		self.init(id: id, context: context)
		
		self.metaDatas = metaDatas ?? []
		self.traductions = traductions ?? []
		self.exemples = exemples ?? []
	}
	
	//MARK: EasyInit's init
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		
		var previewMetaData: [MetaData]? {
			let request:NSFetchRequest<MetaData> = MetaData.fetchRequest()
			do {
				let allMetaDatas = try (context ?? DataController.shared.mainQueueManagedObjectContext).fetch(request)
				if allMetaDatas.isEmpty { return nil }
				var output: [MetaData] = []
				for _ in 1...Int.random(in: 1...5) {
					let newMetaData = allMetaDatas.randomElement()!
					if !(output.contains { $0.id == newMetaData.id }) {
						output.append(allMetaDatas.randomElement()!)
					}
				}
				return output
			}
			catch {
				return nil
			}
		}
		
		var previewTraduction: Set<Traduction> {
			var traductions: Set<Traduction> = []
			for _ in 1...Int.random(in: 1...5) {
				let newTraduction = Traduction(.preview)
				if !(traductions.contains { $0.langue == newTraduction.langue }) {
					traductions.insert(newTraduction)
				}
				else { newTraduction.delete() }
			}
			return traductions
		}
		
		switch type {
		case .empty:
			self.init(id: nil, context: context)
		case .preview:
			self.init(id: UUID(),
					  metaDatas: previewMetaData,
					  traductions: previewTraduction,
					  exemples: nil,
					  context: context)
		}
	}
	
	//MARK: Import init
	convenience init(jsonSenses: [json_Sense], context: NSManagedObjectContext) {
		
		var communMetaData: [String] = []
		var uniqueMetaData: [String] = []
		var linkMetaData: [String] = []
		
		var lsource: [json_Lsource] = []
		var traductionDict: [Langue:String] = [:]
		
		for sense in jsonSenses {
			uniqueMetaData.append(contentsOf: sense.stagk.filter { !uniqueMetaData.contains($0) })
			uniqueMetaData.append(contentsOf: sense.stagr.filter { !uniqueMetaData.contains($0) })
			
			linkMetaData.append(contentsOf: sense.xref.filter { !linkMetaData.contains($0) })
			linkMetaData.append(contentsOf: sense.ant.filter { !linkMetaData.contains($0) })
			
			communMetaData.append(contentsOf: sense.pos.filter { !communMetaData.contains($0) })
			communMetaData.append(contentsOf: sense.field.filter { !communMetaData.contains($0) })
			communMetaData.append(contentsOf: sense.misc.filter { !communMetaData.contains($0) })
			communMetaData.append(contentsOf: sense.dial.filter { !communMetaData.contains($0) })
			
			uniqueMetaData.append(contentsOf: sense.s_inf	.filter { !uniqueMetaData.contains($0) })
			
			lsource.append(contentsOf: sense.lsource.filter{ !lsource.contains($0) })
			
			for gloss in sense.gloss {
				if traductionDict[Langue(rawValue: gloss.lang ?? "") ?? .none] != nil {
					traductionDict[Langue(rawValue: gloss.lang ?? "") ?? .none] =
					([traductionDict[Langue(rawValue: gloss.lang ?? "") ?? .none] ?? ""] + [gloss.value]).joined(separator: ", ")
				}
				else {
					traductionDict[Langue(rawValue: gloss.lang ?? "") ?? .none] = gloss.value
				}
			}
		}
		
		var metaDatas: [MetaData] = []
		
		for metaData in communMetaData {
			if let cachedVersion = CommunMetaData.cache.object(forKey: NSString(string: metaData)) {
				metaDatas.append(cachedVersion)
			} else {
				do {
					let request:NSFetchRequest<CommunMetaData> = CommunMetaData.fetchRequest()
					request.predicate = NSPredicate(format: "ANY traductions_atb.text_atb == %@", metaData)
					let results = try context.fetch(request)
					if results.count == 1 {
						metaDatas.append(results[0])
						CommunMetaData.cache.setObject(results[0], forKey: NSString(string: metaData))
					}
					else {
						fatalError(results.count > 1 ? "Multiple metaData for same text : \"\(metaData)\"" : "No metaData for this text : \"\(metaData)\"" )
					}
				}
				catch {
					fatalError(error.localizedDescription)
				}
			}
		}
		
		for metaData in uniqueMetaData {
			metaDatas.append(UniqueMetaData(langue: .francais, text: metaData, context: context))
		}
		
		for metaData in linkMetaData {
			metaDatas.append(LinkMetaData(langue: .francais, text: metaData, context: context))
		}
		
		var traductions: Set<Traduction> = []
		
		for langue in Langue.JMdictLangues {
			if let traduction = traductionDict[langue] {
				traductions.insert(Traduction(langue: langue, text: traduction, context: context))
			}
		}
		
		
		self.init(id: UUID(),
				  metaDatas: metaDatas,
				  traductions: traductions,
				  exemples: nil,
				  context: context)
	}
}


//MARK: Protocole extentions
extension Sense: Displayable {
	var primary: String? {
		return traductions.firstMatch()?.text
	}
}

extension Sense: EasyInit {}



// MARK: Generated accessors for communMetaDatas_atb
extension Sense {
	
	@objc(insertObject:inCommunMetaDatas_atbAtIndex:)
	@NSManaged public func insertIntoCommunMetaDatas_atb(_ value: CommunMetaData, at idx: Int)
	
	@objc(removeObjectFromCommunMetaDatas_atbAtIndex:)
	@NSManaged public func removeFromCommunMetaDatas_atb(at idx: Int)
	
	@objc(insertCommunMetaDatas_atb:atIndexes:)
	@NSManaged public func insertIntoCommunMetaDatas_atb(_ values: [CommunMetaData], at indexes: NSIndexSet)
	
	@objc(removeCommunMetaDatas_atbAtIndexes:)
	@NSManaged public func removeFromCommunMetaDatas_atb(at indexes: NSIndexSet)
	
	@objc(replaceObjectInCommunMetaDatas_atbAtIndex:withObject:)
	@NSManaged public func replaceCommunMetaDatas_atb(at idx: Int, with value: CommunMetaData)
	
	@objc(replaceCommunMetaDatas_atbAtIndexes:withCommunMetaDatas_atb:)
	@NSManaged public func replaceCommunMetaDatas_atb(at indexes: NSIndexSet, with values: [CommunMetaData])
	
	@objc(addCommunMetaDatas_atbObject:)
	@NSManaged public func addToCommunMetaDatas_atb(_ value: CommunMetaData)
	
	@objc(removeCommunMetaDatas_atbObject:)
	@NSManaged public func removeFromCommunMetaDatas_atb(_ value: CommunMetaData)
	
	@objc(addCommunMetaDatas_atb:)
	@NSManaged public func addToCommunMetaDatas_atb(_ values: NSOrderedSet)
	
	@objc(removeCommunMetaDatas_atb:)
	@NSManaged public func removeFromCommunMetaDatas_atb(_ values: NSOrderedSet)
	
}

// MARK: Generated accessors for uniqueMetaDatas_atb
extension Sense {
	
	@objc(insertObject:inUniqueMetaDatas_atbAtIndex:)
	@NSManaged public func insertIntoUniqueMetaDatas_atb(_ value: UniqueMetaData, at idx: Int)
	
	@objc(removeObjectFromUniqueMetaDatas_atbAtIndex:)
	@NSManaged public func removeFromUniqueMetaDatas_atb(at idx: Int)
	
	@objc(insertUniqueMetaDatas_atb:atIndexes:)
	@NSManaged public func insertIntoUniqueMetaDatas_atb(_ values: [UniqueMetaData], at indexes: NSIndexSet)
	
	@objc(removeUniqueMetaDatas_atbAtIndexes:)
	@NSManaged public func removeFromUniqueMetaDatas_atb(at indexes: NSIndexSet)
	
	@objc(replaceObjectInUniqueMetaDatas_atbAtIndex:withObject:)
	@NSManaged public func replaceUniqueMetaDatas_atb(at idx: Int, with value: UniqueMetaData)
	
	@objc(replaceUniqueMetaDatas_atbAtIndexes:withUniqueMetaDatas_atb:)
	@NSManaged public func replaceUniqueMetaDatas_atb(at indexes: NSIndexSet, with values: [UniqueMetaData])
	
	@objc(addUniqueMetaDatas_atbObject:)
	@NSManaged public func addToUniqueMetaDatas_atb(_ value: UniqueMetaData)
	
	@objc(removeUniqueMetaDatas_atbObject:)
	@NSManaged public func removeFromUniqueMetaDatas_atb(_ value: UniqueMetaData)
	
	@objc(addUniqueMetaDatas_atb:)
	@NSManaged public func addToUniqueMetaDatas_atb(_ values: NSOrderedSet)
	
	@objc(removeUniqueMetaDatas_atb:)
	@NSManaged public func removeFromUniqueMetaDatas_atb(_ values: NSOrderedSet)
	
}

// MARK: Generated accessors for linkMetaData_atb
extension Sense {
	
	@objc(insertObject:inLinkMetaData_atbAtIndex:)
	@NSManaged public func insertIntoLinkMetaData_atb(_ value: LinkMetaData, at idx: Int)
	
	@objc(removeObjectFromLinkMetaData_atbAtIndex:)
	@NSManaged public func removeFromLinkMetaData_atb(at idx: Int)
	
	@objc(insertLinkMetaData_atb:atIndexes:)
	@NSManaged public func insertIntoLinkMetaData_atb(_ values: [LinkMetaData], at indexes: NSIndexSet)
	
	@objc(removeLinkMetaData_atbAtIndexes:)
	@NSManaged public func removeFromLinkMetaData_atb(at indexes: NSIndexSet)
	
	@objc(replaceObjectInLinkMetaData_atbAtIndex:withObject:)
	@NSManaged public func replaceLinkMetaData_atb(at idx: Int, with value: LinkMetaData)
	
	@objc(replaceLinkMetaData_atbAtIndexes:withLinkMetaData_atb:)
	@NSManaged public func replaceLinkMetaData_atb(at indexes: NSIndexSet, with values: [LinkMetaData])
	
	@objc(addLinkMetaData_atbObject:)
	@NSManaged public func addToLinkMetaData_atb(_ value: LinkMetaData)
	
	@objc(removeLinkMetaData_atbObject:)
	@NSManaged public func removeFromLinkMetaData_atb(_ value: LinkMetaData)
	
	@objc(addLinkMetaData_atb:)
	@NSManaged public func addToLinkMetaData_atb(_ values: NSOrderedSet)
	
	@objc(removeLinkMetaData_atb:)
	@NSManaged public func removeFromLinkMetaData_atb(_ values: NSOrderedSet)
	
}

// MARK: Generated accessors for traductions_atb
extension Sense {
	
	@objc(addTraductions_atbObject:)
	@NSManaged public func addToTraductions_atb(_ value: Traduction)
	
	@objc(removeTraductions_atbObject:)
	@NSManaged public func removeFromTraductions_atb(_ value: Traduction)
	
	@objc(addTraductions_atb:)
	@NSManaged public func addToTraductions_atb(_ values: NSSet)
	
	@objc(removeTraductions_atb:)
	@NSManaged public func removeFromTraductions_atb(_ values: NSSet)
	
}

// MARK: Generated accessors for exemples_atb
extension Sense {
	
	@objc(insertObject:inExemples_atbAtIndex:)
	@NSManaged public func insertIntoExemples_atb(_ value: Exemple, at idx: Int)
	
	@objc(removeObjectFromExemples_atbAtIndex:)
	@NSManaged public func removeFromExemples_atb(at idx: Int)
	
	@objc(insertExemples_atb:atIndexes:)
	@NSManaged public func insertIntoExemples_atb(_ values: [Exemple], at indexes: NSIndexSet)
	
	@objc(removeExemples_atbAtIndexes:)
	@NSManaged public func removeFromExemples_atb(at indexes: NSIndexSet)
	
	@objc(replaceObjectInExemples_atbAtIndex:withObject:)
	@NSManaged public func replaceExemples_atb(at idx: Int, with value: Exemple)
	
	@objc(replaceExemples_atbAtIndexes:withExemples_atb:)
	@NSManaged public func replaceExemples_atb(at indexes: NSIndexSet, with values: [Exemple])
	
	@objc(addExemples_atbObject:)
	@NSManaged public func addToExemples_atb(_ value: Exemple)
	
	@objc(removeExemples_atbObject:)
	@NSManaged public func removeFromExemples_atb(_ value: Exemple)
	
	@objc(addExemples_atb:)
	@NSManaged public func addToExemples_atb(_ values: NSOrderedSet)
	
	@objc(removeExemples_atb:)
	@NSManaged public func removeFromExemples_atb(_ values: NSOrderedSet)
	
}

// MARK: Generated accessors for backLink_atb
extension Sense {
	
	@objc(addBackLink_atbObject:)
	@NSManaged public func addToBackLink_atb(_ value: LinkMetaData)
	
	@objc(removeBackLink_atbObject:)
	@NSManaged public func removeFromBackLink_atb(_ value: LinkMetaData)
	
	@objc(addBackLink_atb:)
	@NSManaged public func addToBackLink_atb(_ values: NSSet)
	
	@objc(removeBackLink_atb:)
	@NSManaged public func removeFromBackLink_atb(_ values: NSSet)
	
}
