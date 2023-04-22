//
//  ListClickableText.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/06.
//

import Foundation
import SwiftUI

struct ListClickableText: ViewModifier {
	var action: (() -> Void)?
	
	func body(content: Content) -> some View {
		ZStack(alignment: .leading) {
			content
				.foregroundColor(action == nil ? .primary : .accentColor)
			Color.clear
				.contentShape(Rectangle())
				.onTapGesture {
					action?()
				}
		}
	}
}

extension Text {
	func clickable(action: (() -> Void)?) -> some View {
		self.modifier(ListClickableText(action: action))
	}
}

struct ListClickableText_Previews: PreviewProvider {
	static var previews: some View {
		List {
			Text("Clickable Row")
				.clickable {
					print(Date().timeIntervalSince1970)
				}
			Text("Normal Text")
		}
		
		
		List {
			Text("Veeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeery long Clickable Row")
				.clickable {
					print(Date().timeIntervalSince1970)
				}
			Text("Veeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeery long Normal Text")
		}
	}
}
