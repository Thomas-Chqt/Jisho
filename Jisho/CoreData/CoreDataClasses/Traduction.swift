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
	
	//MARK: FetchRequests
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Traduction> {
		return NSFetchRequest<Traduction>(entityName: "Traduction")
	}
	
	
	//MARK: NSManaged attributs
	@NSManaged private var parentMot_atb: Mot?
	@NSManaged private var parentSense_atb: Sense?
	@NSManaged private var parentMetaData_atb: MetaData?
	@NSManaged private var parentExemple_atb: Exemple?

	@NSManaged private var langue_atb: String?
	@NSManaged private var text_atb: String?
	
	
	//MARK: Computed variables
	var langue: Langue {
		get {
			guard let langue_atb = langue_atb else { return .none }
			return Langue(rawValue: langue_atb) ?? Langue.none
		}
		set {
			self.parentSense_atb?.objectWillChange.send()
			langue_atb = newValue.rawValue
		}
	}
		
	var text: String {
		get {
			return text_atb ?? ""
		}
		set {
			self.parentMetaData_atb?.objectWillChange.send()
			text_atb = newValue
		}
	}
	
	
	//MARK: inits
	convenience init(id: UUID? = nil,
					 langue: Langue = .none,
					 text: String? = nil,
					 context: NSManagedObjectContext? = nil) {
		self.init(id: id, context: context)
		
		self.langue = langue
		self.text = text ?? ""
	}
	
	//MARK: EasyInit's init
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
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


//MARK: Protocole extentions
extension Traduction: Displayable {
	var primary: String? {
		text
	}
	
	var secondary: String? {
		langue.fullName
	}
}

extension Traduction: EasyInit { }


//MARK: Array extentions
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
		return self.filter { $0.langue == Langue.first }.first
	}
}
