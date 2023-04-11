//
//  NavBarEditButton.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/07.
//

import Foundation
import SwiftUI

struct NavBarEditButton: ViewModifier {
	
	@State var editMode = EditMode.inactive

	func body(content: Content) -> some View {
		content
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					if editMode == .inactive {
						Button("Modifier") {
							withAnimation {
								editMode = .active
							}
						}
					}
					else {
						Button("Ok") {
							withAnimation {
								editMode = .inactive
							}
						}
					}
				}
			}
			.environment(\.editMode, $editMode)
	}
	
}


extension View {
	func navBarEditButton() -> some View {
		self.modifier(NavBarEditButton())
	}
}


struct NavBarEditButton_preview: PreviewProvider {
	
	static var previews: some View {
		NavigationStack {
			List {
				ForEach(1...10, id: \.self) { _ in
					Text("Test")
				}
				.onDelete(perform: {_ in})
				.onMove(perform: {_,_  in})
			}
			.navBarEditButton()
		}
	}
}
