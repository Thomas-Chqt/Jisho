//
//  AppPage.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import Foundation
import SwiftUI

enum AppPages {
	case search
	case listes
	case settings
	case debug
		
	var fullName: String {
		switch self {
		case .search:
			return "Recherche"
		case .listes:
			return "Listes"
		case .settings:
			return "Réglages"
		case .debug:
			return "Debug"
		}
	}
	
	var icone: Image {
		switch self {			
		case .search:
			return Image(systemName: "magnifyingglass")
		case .listes:
			return Image(systemName: "list.bullet.rectangle.portrait")
		case .settings:
			return Image(systemName: "gearshape")
		case .debug:
			return Image(systemName: "wrench")
		}
	}
	
}
