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
	
	//MARK: FetchRequests
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Japonais> {
		return NSFetchRequest<Japonais>(entityName: "Japonais")
	}
	
	
	//MARK: NSManaged attributs
	@NSManaged private var kanjis_atb: String?
	@NSManaged private var kanas_atb: String?
	@NSManaged private var parent_atb: Mot?
	
	
	//MARK: Computed variables
	var kanjis: [String] {
		get {
			guard let kanjis_atb = kanjis_atb else { return [] }
			let kanjis = kanjis_atb.split(separator: "␚", omittingEmptySubsequences: false)
			return kanjis.map { subString in String(subString) }
		}
		set {
			if newValue.isEmpty { kanjis_atb = nil ; return }
			kanjis_atb = newValue.joined(separator: "␚")
		}
	}
	
	
	//MARK: Functions
	var kanas: [String] {
		get {
			guard let kanas_atb = kanas_atb else { return [] }
			let kanas = kanas_atb.split(separator: "␚", omittingEmptySubsequences: false)
			return kanas.map { subString in String(subString) }
		}
		set {
			if newValue.isEmpty { kanas_atb = nil ; return }
			kanas_atb = newValue.joined(separator: "␚")
		}
	}
	
	func kanjiBinding(for index: Int) -> Binding<String>? {
		if !self.kanjis.indices.contains(index) { return nil }
		return Binding(get: { self.kanjis[index] },
					   set: { self.kanjis[index] = $0 })
	}
	
	func kanaBinding(for index: Int) -> Binding<String>? {
		if !self.kanas.indices.contains(index) { return nil }
		return Binding(get: { self.kanas[index] },
					   set: { self.kanas[index] = $0 })
	}
	
	//MARK: inits
	convenience init(id: UUID? = nil,
					 kanjis: [String]? = nil,
					 kanas: [String]? = nil,
					 context: NSManagedObjectContext? = nil) {
		self.init(id: id, context: context)
		
		self.kanjis = kanjis ?? []
		self.kanas = kanas ?? []
	}
	
	//MARK: EasyInit's init
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		let previewKanjis = [["猫"], ["犬"], ["私", "俺"], ["馬"]]
		let previewKanas = [["ねこ"], ["いぬ"], ["わたし", "おれ"], ["うま"]]
		
		switch type {
		case .empty:
			self.init(id: nil, context: context)
		case .preview:
			self.init(kanjis: previewKanjis.randomElement()!,
					  kanas: previewKanas.randomElement()!,
					  context: context)
		}
	}
}


//MARK: Protocole extentions
extension Japonais: Displayable {
	var primary: String? {
		return kanjis.first
	}
	
	var secondary: String? {
		return kanas.first
	}
}

extension Japonais: EasyInit { }
