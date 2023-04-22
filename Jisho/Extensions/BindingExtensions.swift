//
//  BindingExtensions.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/22.
//

import Foundation
import SwiftUI

extension Binding where Value == CommunMetaData {
	var optionalValue: Binding<CommunMetaData?> {
		Binding<CommunMetaData?> (
			get: { self.wrappedValue },
			set: {
				guard let newValue = $0 else { return }
				self.wrappedValue = newValue
			}
		)
	}
}

extension Binding where Value == String? {
	var nonOptional: Binding<String> {
		Binding<String> (
			get: { self.wrappedValue ?? "" },
			set: { self.wrappedValue = $0 }
		)
	}
}
