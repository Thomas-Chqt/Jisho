//
//  CoreDataEntityType.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/03.
//

import Foundation

enum CoreDataEntityType: Hashable {
	case mot(Mot?)
	case japonais(Japonais?)
	case sense(Sense?)
	case metaData(CommunMetaData?)
	case traduction(Traduction?)
	case exemple(Exemple?)
	
	init?(_ description: String) {
		switch description {
		case Mot.description():
			self = .mot(nil)
		case Japonais.description():
			self = .japonais(nil)
		case Sense.description():
			self = .sense(nil)
		case CommunMetaData.description():
			self = .metaData(nil)
		case Traduction.description():
			self = .traduction(nil)
		case Exemple.description():
			self = .exemple(nil)
		default:
			return nil
		}
	}
	
	init?(_ entity: Entity) {
		if let mot = entity as? Mot {
			self = .mot(mot)
			return
		}
		if let japonais = entity as? Japonais {
			self = .japonais(japonais)
			return
		}
		if let sense = entity as? Sense {
			self = .sense(sense)
			return
		}
		if let metaData = entity as? CommunMetaData {
			self = .metaData(metaData)
			return
		}
		if let traduction = entity as? Traduction {
			self = .traduction(traduction)
			return
		}
		if let exemple = entity as? Exemple {
			self = .exemple(exemple)
			return
		}
		return nil
	}
}
