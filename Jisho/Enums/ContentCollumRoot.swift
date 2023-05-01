//
//  AppPage.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import Foundation
import SwiftUI

enum ContentCollumRoot: Identifiable {
	case search
	case listes
	case settings
	case debug
	
	var id: ContentCollumRoot {
		return self
	}
	
	static var sideMenuList: [ContentCollumRoot] {
		return [
			ContentCollumRoot.search,
			ContentCollumRoot.listes,
			ContentCollumRoot.settings,
			ContentCollumRoot.debug
		]
	}
	
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
	
	@ViewBuilder
	func view(selection: Binding<DetailCollumRoot?>) -> some View {
		switch self {
		case .search:
			Text("Search")
		case .listes:
			Text("List")
		case .settings:
			SettingsPageView(selection: selection)
		case .debug:
			DebugPageView(selection: selection)
		}
	}
	
}
