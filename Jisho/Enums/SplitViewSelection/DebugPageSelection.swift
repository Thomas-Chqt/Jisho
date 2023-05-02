//
//  DebugPageSelection.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import Foundation
import SwiftUI

enum DebugPageSelection: SplitViewSelection {
	case entity(Entity)
	case JMdictDebug
	
	@ViewBuilder
	var view: some View {
		switch self {
			case .entity(let entity):
				EntityDetailViewWrapper(entity: entity)
			case .JMdictDebug:
				JMdictDebugView()
		}
	}
}
