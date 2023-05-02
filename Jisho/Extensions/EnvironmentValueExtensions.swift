//
//  EnvironmentValueExtensions.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import Foundation
import SwiftUI

private struct ToggleSideMenuEnvironmentKey: EnvironmentKey {
	static var defaultValue: () -> Void = { }
}

extension EnvironmentValues {
	var toggleSideMenu: () -> Void {
		get { self[ToggleSideMenuEnvironmentKey.self] }
		set { self[ToggleSideMenuEnvironmentKey.self] = newValue }
	}
}
