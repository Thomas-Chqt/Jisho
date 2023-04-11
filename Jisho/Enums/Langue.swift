//
//  Langue.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/05.
//

import Foundation

enum Langue: String, CaseIterable, Codable, Identifiable {
	
//	case japonais = "jpn"
	case francais = "fre"
	case anglais = "eng"
	case espagnol = "spa"
	case russe = "rus"
	case neerlandais = "dut"
	case allemand = "ger"
	case hongrois = "hun"
	case suedois = "swe"
	case slovene = "slv"
	case none = "none"
	
	var id: UUID { UUID() }
	
	static var allUsableCases: [Langue] {
		return allCases.filter { $0 != .none }
	}
	
	static var first: Langue {
		Settings.shared.langueOrder.filter {
			Settings.shared.selectedLangues.contains($0)
		}.first ?? .none
	}
	
	static var orderedSelected: [Langue] {
		Settings.shared.langueOrder.filter {
			Settings.shared.selectedLangues.contains($0)
		}
	}
	
	var flag:String {
		switch self {
//		case .japonais:
//			return "🇯🇵"
		case .francais:
			return "🇫🇷"
		case .anglais:
			return "🇬🇧"
		case .espagnol:
			return "🇪🇸"
		case .russe:
			return "🇷🇺"
		case .neerlandais:
			return "🇳🇱"
		case .allemand:
			return "🇩🇪"
		case .hongrois:
			return "🇭🇺"
		case .suedois:
			return "🇸🇪"
		case .slovene:
			return "🇸🇮"
		case .none:
			return "🇺🇳"
		}
	}
	
	var fullName:String {
		switch self {
//		case .japonais:
//			return "Japonais"
		case .francais:
			return "Français"
		case .anglais:
			return "Anglais"
		case .espagnol:
			return "Espagnol"
		case .russe:
			return "Russe"
		case .neerlandais:
			return "Néerlandais"
		case .allemand:
			return "Allemand"
		case .hongrois:
			return "Hongrois"
		case .suedois:
			return "Suédois"
		case .slovene:
			return "Slovène"
		case .none:
			return "Pas de langue"
		}
	}
}
