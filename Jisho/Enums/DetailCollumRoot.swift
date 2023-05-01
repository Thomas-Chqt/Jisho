//
//  DetailCollumRoot.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/28.
//

import Foundation
import SwiftUI

enum DetailCollumRoot: Hashable {
	case entity(Entity)
	case langueSettings
	
	@ViewBuilder var view: some View {
		switch self {
		case .entity(let entity):
			EntityDetailViewWrapper(entity: entity)
		case .langueSettings:
			LanguesSettingsView()
		}
	}
}
