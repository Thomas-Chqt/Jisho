//
//  SettingsPageSelection.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import Foundation
import SwiftUI

enum SettingsPageSelection: SplitViewSelection {
	case languesSettings
	
	@ViewBuilder
	var view: some View {
		switch self {
		case .languesSettings:
			LanguesSettingsView()
		}
	}
}
