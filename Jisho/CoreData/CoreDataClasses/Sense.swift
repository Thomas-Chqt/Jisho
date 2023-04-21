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
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Sense> {
		return NSFetchRequest<Sense>(entityName: "Sense")
	}
	@NSManaged private var parent_atb: Mot?
	
	@NSManaged private var metaDatas_atb: NSOrderedSet?
	@NSManaged public var traductions_atb: NSSet?
	@NSManaged private var exemples_atb: NSOrderedSet?
	
	var metaDatas: [MetaData]? {
		get {
			guard let metaDatas_atb = metaDatas_atb else { return nil }
			let metaData = metaDatas_atb.array as! [MetaData]
			if metaData.isEmpty { return nil }
			return metaData
		}
		set {
			guard let newValue = newValue else { metaDatas_atb = nil ; return}
			if newValue.isEmpty { metaDatas_atb = nil ; return}
			metaDatas_atb = NSOrderedSet(array: newValue)
		}
	}
	
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
	
	var exemples: [Exemple]? {
		get {
			guard let exemples_atb = exemples_atb else { return nil }
			let exemples = exemples_atb.array as! [Exemple]
			if exemples.isEmpty { return nil }
			return exemples
		}
		set {
			guard let newValue = newValue else { exemples_atb = nil ; return}
			if newValue.isEmpty { exemples_atb = nil ; return}
			exemples_atb = NSOrderedSet(array: newValue)
		}
	}
	
	
	func removeMetaData(_ metaData: MetaData) {
		self.removeFromMetaDatas_atb(metaData)
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
	
	
	func metaDataBinding(for index: Int) -> Binding<MetaData?>? {
		guard let metaDatas = self.metaDatas else { return nil }
		guard metaDatas.indices.contains(index) else { return nil }
		
		return Binding {
			metaDatas[index]
		} set: {
			guard let newValue = $0 else { return }
			self.metaDatas![index] = newValue
		}
	}
	
	func metaDataBinding(for index: Int) -> Binding<MetaData>? {
		guard let metaDatas = self.metaDatas else { return nil }
		guard metaDatas.indices.contains(index) else { return nil }
		
		return Binding {
			metaDatas[index]
		} set: {
			self.metaDatas![index] = $0
		}
	}
	
	convenience init(id: UUID,
					 metaDatas: [MetaData]? = nil,
					 traductions: Set<Traduction>? = nil,
					 exemples: [Exemple]? = nil,
					 context: NSManagedObjectContext) {
		self.init(id: id, context: context)
		
		self.metaDatas = metaDatas
		self.traductions = traductions
		self.exemples = exemples
	}
	
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		let context:NSManagedObjectContext = context ?? DataController.shared.mainQueueManagedObjectContext
		
		var previewMetaData: [MetaData]? {
			let request:NSFetchRequest<MetaData> = MetaData.fetchRequest()
			do {
				let allMetaDatas = try context.fetch(request)
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
			self.init(id: UUID(), context: context)
		case .preview:
			self.init(id: UUID(),
					  metaDatas: previewMetaData,
					  traductions: previewTraduction,
					  exemples: nil,
					  context: context)
		}
	}
	
	convenience init(jsonSenses: [json_Sense], context: NSManagedObjectContext) {
		
		var communMetaData: [String] = []
		var linkMetaData: [String] = []
		var uniqueMetaData: [String] = []
		
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
			if let cachedVersion = MetaData.cache.object(forKey: NSString(string: metaData)) {
				metaDatas.append(cachedVersion)
			} else {
				do {
					let request:NSFetchRequest<MetaData> = MetaData.fetchRequest()
					request.predicate = NSPredicate(format: "ANY traductions_atb.text_atb == %@", metaData)
					let results = try context.fetch(request)
					if results.count == 1 {
						metaDatas.append(results[0])
						MetaData.cache.setObject(results[0], forKey: NSString(string: metaData))
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
		
		var traductions: Set<Traduction> = []
		
		for langue in Langue.JMdictLangues {
			if let traduction = traductionDict[langue] {
				traductions.insert(Traduction(id: UUID(), langue: langue, text: traduction, context: context))
			}
		}
		
		
		self.init(id: UUID(),
				  metaDatas: metaDatas,
				  traductions: traductions,
				  exemples: nil,
				  context: context)
	}
}

extension Sense: Displayable {
	var primary: String? {
		return traductions?.firstMatch()?.text
	}
}

extension Sense: EasyInit {
	
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

// MARK: Generated accessors for metaDatas_atb
extension Sense {
	
	@objc(insertObject:inMetaDatas_atbAtIndex:)
	@NSManaged public func insertIntoMetaDatas_atb(_ value: MetaData, at idx: Int)
	
	@objc(removeObjectFromMetaDatas_atbAtIndex:)
	@NSManaged public func removeFromMetaDatas_atb(at idx: Int)
	
	@objc(insertMetaDatas_atb:atIndexes:)
	@NSManaged public func insertIntoMetaDatas_atb(_ values: [MetaData], at indexes: NSIndexSet)
	
	@objc(removeMetaDatas_atbAtIndexes:)
	@NSManaged public func removeFromMetaDatas_atb(at indexes: NSIndexSet)
	
	@objc(replaceObjectInMetaDatas_atbAtIndex:withObject:)
	@NSManaged public func replaceMetaDatas_atb(at idx: Int, with value: MetaData)
	
	@objc(replaceMetaDatas_atbAtIndexes:withMetaDatas_atb:)
	@NSManaged public func replaceMetaDatas_atb(at indexes: NSIndexSet, with values: [MetaData])
	
	@objc(addMetaDatas_atbObject:)
	@NSManaged public func addToMetaDatas_atb(_ value: MetaData)
	
	@objc(removeMetaDatas_atbObject:)
	@NSManaged public func removeFromMetaDatas_atb(_ value: MetaData)
	
	@objc(addMetaDatas_atb:)
	@NSManaged public func addToMetaDatas_atb(_ values: NSOrderedSet)
	
	@objc(removeMetaDatas_atb:)
	@NSManaged public func removeFromMetaDatas_atb(_ values: NSOrderedSet)
	
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
