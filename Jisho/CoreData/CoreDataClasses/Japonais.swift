//
//  Japonais.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/02.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Japonais)
public class Japonais: Entity {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Japonais> {
		return NSFetchRequest<Japonais>(entityName: "Japonais")
	}
	
	@NSManaged private var kanjis_atb: String?
	@NSManaged private var kanas_atb: String?

	@NSManaged private var parent_atb: Mot?
	
	
	var kanjis: [String]? {
		get {
			guard let kanjis_atb = kanjis_atb else { return nil }
//			if kanjis_atb.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return nil }
			let kanjis = kanjis_atb.split(separator: "␚", omittingEmptySubsequences: false)
			if kanjis.isEmpty { return nil }
			return kanjis.map { subString in String(subString) }
		}
		set {
			guard let newValue = newValue else { kanjis_atb = nil ; return }
			if newValue.isEmpty { kanjis_atb = nil ; return }
			kanjis_atb = newValue.joined(separator: "␚")
		}
	}
	
	var kanas: [String]? {
		get {
			guard let kanas_atb = kanas_atb else { return nil }
//			if kanas_atb.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return nil }
			let kanas = kanas_atb.split(separator: "␚", omittingEmptySubsequences: false)
			if kanas.isEmpty { return nil }
			return kanas.map { subString in String(subString) }
		}
		set {
			guard let newValue = newValue else { kanas_atb = nil ; return }
			if newValue.isEmpty { kanas_atb = nil ; return }
			kanas_atb = newValue.joined(separator: "␚")
		}
	}
	
	func kanjiBinding(for index: Int) -> Binding<String>? {
		if self.kanjis == nil { return nil }
		return Binding(get: {self.kanjis![index]},
					   set: {self.kanjis![index] = $0})
	}
	
	func kanaBinding(for index: Int) -> Binding<String>? {
		if self.kanas == nil { return nil }
		return Binding(get: {self.kanas![index]},
					   set: {self.kanas![index] = $0})
	}
	
	convenience init(id: UUID,
					 kanjis: [String]? = nil,
					 kanas: [String]? = nil,
					 context: NSManagedObjectContext) {
		self.init(id: id, context: context)
		
		self.kanjis = kanjis
		self.kanas = kanas
	}
	
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		let context:NSManagedObjectContext = context ?? DataController.shared.mainQueueManagedObjectContext
		
		let previewKanjis = [["猫"], ["犬"], ["私", "俺"], ["馬"]]
		let previewKanas = [["ねこ"], ["いぬ"], ["わたし", "おれ"], ["うま"]]
		
		switch type {
		case .empty:
			self.init(id: UUID(), context: context)
		case .preview:
			self.init(id: UUID(),
					  kanjis: previewKanjis.randomElement()!,
					  kanas: previewKanas.randomElement()!,
					  context: context)
		}
	}
}


extension Japonais: Displayable {
	var primary: String? {
		return kanjis?.first
	}
	
	var secondary: String? {
		return kanas?.first
	}
}


extension Japonais: EasyInit {
	
}
