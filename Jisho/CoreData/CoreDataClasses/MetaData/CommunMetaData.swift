//
//  CommunMetaData.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/21.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(CommunMetaData)
public class CommunMetaData: MetaData {
	
	//MARK: FetchRequests
	@nonobjc public class func fetchRequest() -> NSFetchRequest<CommunMetaData> {
		return NSFetchRequest<CommunMetaData>(entityName: "CommunMetaData")
	}
	
	//MARK: NSManaged attributs
	@NSManaged public var senseIn_atb: NSOrderedSet?
	
	//MARK: EasyInit's init
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		let previewTexts = ["Nom commun", "Verbe", "Adjectif", "Nom propre"]
		
		switch type {
		case .empty:
			self.init(id: nil, context: context)
		case .preview:
			self.init(text: previewTexts.randomElement()!, context: context)
		}
	}
	
	//MARK: Import init
	convenience init(jsonMetaData: json_MetaData, context: NSManagedObjectContext) {

		let traductions: Set<Traduction> = [ Traduction(langue: .francais, text: jsonMetaData.fr, context: context),
											 Traduction(langue: .anglais,  text: jsonMetaData.en, context: context) ]
		self.init(traductions: traductions, context: context)
	}
}

//MARK: Protocole extentions
extension CommunMetaData: EasyInit {}

extension CommunMetaData?: Identifiable {
	public var id: UUID? {
		return self?.id
	}
}


//MARK: Array extentions
extension Array where Element == CommunMetaData {
	func filter(by filter: String) -> [CommunMetaData] {
		return self.filter { metaData in
			if filter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return true }
			return metaData.text?.localizedStandardContains(filter) ?? false
		}
	}
}

extension FetchedResults where Result == CommunMetaData {
	func filtered(by filter: String) -> [CommunMetaData] {
		return self.map { $0 }.filter(by: filter)
	}
}

//MARK: Other extentions
extension CommunMetaData {
	static let cache = NSCache<NSString, CommunMetaData>()
}

// MARK: Generated accessors for senseIn_atb
extension CommunMetaData {
	
	@objc(insertObject:inSenseIn_atbAtIndex:)
	@NSManaged public func insertIntoSenseIn_atb(_ value: Sense, at idx: Int)
	
	@objc(removeObjectFromSenseIn_atbAtIndex:)
	@NSManaged public func removeFromSenseIn_atb(at idx: Int)
	
	@objc(insertSenseIn_atb:atIndexes:)
	@NSManaged public func insertIntoSenseIn_atb(_ values: [Sense], at indexes: NSIndexSet)
	
	@objc(removeSenseIn_atbAtIndexes:)
	@NSManaged public func removeFromSenseIn_atb(at indexes: NSIndexSet)
	
	@objc(replaceObjectInSenseIn_atbAtIndex:withObject:)
	@NSManaged public func replaceSenseIn_atb(at idx: Int, with value: Sense)
	
	@objc(replaceSenseIn_atbAtIndexes:withSenseIn_atb:)
	@NSManaged public func replaceSenseIn_atb(at indexes: NSIndexSet, with values: [Sense])
	
	@objc(addSenseIn_atbObject:)
	@NSManaged public func addToSenseIn_atb(_ value: Sense)
	
	@objc(removeSenseIn_atbObject:)
	@NSManaged public func removeFromSenseIn_atb(_ value: Sense)
	
	@objc(addSenseIn_atb:)
	@NSManaged public func addToSenseIn_atb(_ values: NSOrderedSet)
	
	@objc(removeSenseIn_atb:)
	@NSManaged public func removeFromSenseIn_atb(_ values: NSOrderedSet)
	
}
