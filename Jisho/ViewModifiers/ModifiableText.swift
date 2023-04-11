//
//  ModifiableText.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/10.
//

import Foundation
import SwiftUI

struct ModifiableText: ViewModifier {
	
	@FocusState var isFocus: Bool
		
	@Binding var text: String
	
	@Binding var editState: UUID?
	var equals: UUID
	

	func body(content: Content) -> some View {
		if editState == equals {
			TextField("", text: $text).focused($isFocus)
				.onSubmit { editState = nil }
				.onAppear { isFocus = true }
				.onChange(of: isFocus) {
					if $0 == false && editState == equals { editState = nil }
				}
		}
		else {
			HStack {
				content
				
				Button {
					editState = equals
				} label: {
					Image(systemName: "pencil.circle")
				}
			}
		}
	}
}


extension View {
	
	func editable(text binding: Binding<String>, editState: Binding<UUID?>, equals: UUID ) -> some View {
		self.modifier(ModifiableText(text: binding, editState: editState, equals: equals))
	}
}


struct ModifiableText_Preview: PreviewProvider {
	
	static var previews: some View {
		WrappedView()
	}
	
	struct WrappedView: View {
		
		@State var editState: UUID?
		
		let metaDatas: [MetaData] = [MetaData(.preview), MetaData(.preview), MetaData(.preview)]
						
		var body: some View {
			List {
				TextField("test", text: .constant(""))
				ForEach(metaDatas) { metaData in
					Text(metaData.text ?? "")
						.editable(text: metaData.bindingText,
								  editState: $editState,
								  equals: metaData.id)
					Button("focus") {
						editState = metaData.id
					}
						
				}
			}
		}
	}
}
