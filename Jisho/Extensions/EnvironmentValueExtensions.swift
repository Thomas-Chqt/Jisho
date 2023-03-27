//
//  EnvironmentValueExtensions.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import Foundation
import SwiftUI

//MARK: toggleSideMenu
private struct ToggleSideMenuEnvironmentKey: EnvironmentKey {
	static var defaultValue: () -> Void = { }
}

extension EnvironmentValues {
	var toggleSideMenu: () -> Void {
		get { self[ToggleSideMenuEnvironmentKey.self] }
		set { self[ToggleSideMenuEnvironmentKey.self] = newValue }
	}
}


//MARK: switchPage
private struct SwichPageEnvironmentKey: EnvironmentKey {
	static var defaultValue: (AppPage) -> Void = { _ in }
}

extension EnvironmentValues {
	var switchPage: (AppPage) -> Void {
		get { self[SwichPageEnvironmentKey.self] }
		set { self[SwichPageEnvironmentKey.self] = newValue }
	}
}


//MARK: appGeometry
private struct AppGeometryEnvironmentKey: EnvironmentKey {
	static var defaultValue: GeometryProxy? = nil
}

extension EnvironmentValues {
	var appGeometry: GeometryProxy? {
		get { self[AppGeometryEnvironmentKey.self] }
		set { self[AppGeometryEnvironmentKey.self] = newValue }
	}
}
