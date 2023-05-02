//
//  ShowSideMenuButton.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import Foundation
import SwiftUI

struct ShowSideMenuButton: ViewModifier {
	@Environment(\.toggleSideMenu) var showSideMenu
	
	func body(content: Content) -> some View {
		content
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: showSideMenu) {
						Image(systemName: "list.bullet")
						
					}
				}
			}
	}
}

extension View {
	func showSideMenuButton() -> some View {
		self.modifier(ShowSideMenuButton())
	}
}
