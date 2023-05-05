//
//  AddButton.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/04.
//

import SwiftUI

struct AddButton: ViewModifier {
	
	var addOne: () -> Void
	
	init(_ addOne: @escaping () -> Void) {
		self.addOne = addOne
	}
	
	func body(content: Content) -> some View {
		content
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: addOne,
						   label: { Image(systemName: "plus") })
				}
			}
	}
}

extension View {
	func addButton(_ addOne: @escaping () -> Void) -> some View {
		self.modifier(AddButton(addOne))
	}
	
	func addButton(_ addN: @escaping (Int) -> Void) -> some View {
		self.modifier(AddButton({ addN(1) }))
	}
}


struct AddButton_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			Text("Hello, world!")
				.addButton {
					print("Add")
				}
		}
	}
}
