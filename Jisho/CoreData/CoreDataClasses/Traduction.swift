//
//  Traduction.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/05.
//
//

import Foundation
import CoreData
import Combine

@objc(Traduction)
public class Traduction: Entity {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Traduction> {
		return NSFetchRequest<Traduction>(entityName: "Traduction")
	}
	
	@NSManaged private var parentMot_atb: Mot?
	@NSManaged private var parentSense_atb: Sense?
	@NSManaged private var parentMetaData_atb: MetaData?
	@NSManaged private var parentExemple_atb: Exemple?

	
	
	@NSManaged public var langue_atb: String?
	@NSManaged public var text_atb: String?
	
	var langue: Langue {
		get {
			guard let langue_atb = langue_atb else { return .none }
			return Langue(rawValue: langue_atb) ?? Langue.none
		}
		set {
			langue_atb = newValue.rawValue
		}
	}
		
	var text: String? {
		get {
			guard let text_atb = text_atb else { return nil }
			if text_atb.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return nil }
			return text_atb
		}
		set {
			guard let newValue = newValue else { text_atb = nil ; return }
			if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { text_atb = nil ; return }
			text_atb = newValue
		}
	}
	
	func parentObjectWillChange() -> ObservableObjectPublisher {
		if let objWillChange = parentMot_atb?.objectWillChange { return objWillChange }
		if let objWillChange = parentSense_atb?.objectWillChange { return objWillChange }
		if let objWillChange = parentMetaData_atb?.objectWillChange { return objWillChange }
		if let objWillChange = parentExemple_atb?.objectWillChange { return objWillChange }
		fatalError("Traduction has no parent")
	}
	
	convenience init(id: UUID,
					 langue: Langue = .none,
					 text: String? = nil,
					 context: NSManagedObjectContext) {
		self.init(id: id, context: context)
		
		self.langue = langue
		self.text = text
	}
	
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		let context:NSManagedObjectContext = context ?? DataController.shared.mainQueueManagedObjectContext

		let previewLangues:[Langue] = [.francais, .anglais, .espagnol, .allemand]
		
		let previewTexts:[String?] = [
			"chat, chatte, minou",
			"chien, ouaf ouaf, dogy dogy",
			"cheval, dada"
		]
		
		switch type {
		case .empty:
			self.init(id: UUID(), context: context)
		case .preview:
			self.init(id: UUID(),
					  langue: previewLangues.randomElement()!,
					  text: previewTexts.randomElement()!,
					  context: context)
		}
	}
}

extension Traduction: Displayable {
	var primary: String? {
		text
	}
	
	var secondary: String? {
		langue.fullName
	}
}

extension Traduction: EasyInit {
	
}


extension Set where Element == Traduction {
	
	func filter(using selectedLangues: Set<Langue> = Settings.shared.selectedLangues) -> Set<Element> {
		return self.filter { selectedLangues.contains($0.langue) || $0.langue == .none }
	}
	
	func sorted(using langueOrder:[Langue] = Settings.shared.langueOrder) -> Array<Element> {
		return self.sorted { (traductionA, traductionB) -> Bool in
			guard let indexA = langueOrder.firstIndex(where: { $0 == traductionA.langue }) else { return false }
			guard let indexB = langueOrder.firstIndex(where: { $0 == traductionB.langue }) else { return true }
			
			return indexA < indexB
		}
	}
	
	func fitToSettings(using setttings: Settings = Settings.shared) -> Array<Element> {
		return self
			.filter(using: setttings.selectedLangues)
			.sorted(using: setttings.langueOrder)
	}
	
	func firstMatch(using settings: Settings = Settings.shared) -> Element? {
		return self.fitToSettings(using: settings).first
	}
	
	//can only return a trad of the first langue in selected langues
	func firstLangue(using settings: Settings = Settings.shared) -> Element? {
		guard let firstMatch = self.firstMatch(using: settings) else { return nil }
		let sortedSelectedLangue = settings.langueOrder.compactMap {
			if settings.selectedLangues.contains($0) {
				return $0
			}
			else {
				return nil as Langue?
			}
		}
		if firstMatch.langue == sortedSelectedLangue.first {
			return firstMatch
		}
		else {
			return nil
		}
	}
}
