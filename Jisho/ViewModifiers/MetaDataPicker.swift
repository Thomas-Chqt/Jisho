//
//  MetaDataPicker.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/09.
//

import Foundation
import SwiftUI

struct MetaDataPicker: ViewModifier {
	
	@Binding var replacedMetaData: Binding<MetaData?>?
	var excludedMetaData: [UUID]?
	
	func body(content: Content) -> some View {
		content
			.sheet(item: $replacedMetaData) { binding in
				MetaDataPickerSheeView(replacedMetaData: binding, excludedMetaData: excludedMetaData)
			}
	}
}

extension View {
	func metaDataPicker(replacedMetaData: Binding<Binding<MetaData?>?>, excludedMetaData: [UUID]?) -> some View {
		self.modifier(MetaDataPicker(replacedMetaData: replacedMetaData, excludedMetaData: excludedMetaData))
	}
}
