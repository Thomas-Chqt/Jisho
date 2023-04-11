//
//  SheetDismissButton.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/06.
//

import Foundation
import SwiftUI

struct SheetDismissButton: ViewModifier {
	@Environment(\.dismiss) var dismiss
	
	var text: String
	
	func body(content: Content) -> some View {
		content
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(text) {
						dismiss()
					}
					.padding()
				}
			}
	}
}

extension View {
	func dismissButton(_ text: String) -> some View {
		self.modifier(SheetDismissButton(text: text))
	}
}

struct SheetDismissButton_Previews: PreviewProvider {
	static var previews: some View {
		wrappedView()
	}
	
	struct wrappedView: View {
		
		@State var showSheet: Bool = true
		
		var body: some View {
			Button("Show Sheet") {
				showSheet.toggle()
			}
			.sheet(isPresented: $showSheet) {
				NavigationStack {
					Text("")
						.dismissButton("OK")
				}
			}
		}
	}
}
