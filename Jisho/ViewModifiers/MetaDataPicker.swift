//
//  MetaDataPicker.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/09.
//

import Foundation
import SwiftUI

struct MetaDataPicker: ViewModifier {
	
	@Binding var selectedMetaData: Binding<CommunMetaData?>?
	var excludedIDs: [UUID]?
	
	func body(content: Content) -> some View {
		content
			.sheet(item: $selectedMetaData) { binding in
				MetaDataPickerView(selectedMetaData: binding, excludedIDs: excludedIDs)
			}
	}
}

extension View {
	func metaDataPicker(selectedMetaData: Binding<Binding<CommunMetaData?>?>, excludedIDs: [UUID]? = nil) -> some View {
		self.modifier(MetaDataPicker(selectedMetaData: selectedMetaData, excludedIDs: excludedIDs))
	}
	
	func metaDataPicker(selectedMetaData: Binding<Binding<CommunMetaData?>?>, inSense: Sense? = nil) -> some View {
		self.modifier(MetaDataPicker(selectedMetaData: selectedMetaData, excludedIDs: inSense?.communMetaDatas.map { $0.id }))
	}
}
