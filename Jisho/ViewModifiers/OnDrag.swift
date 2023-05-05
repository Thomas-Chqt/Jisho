//
//  OnDrag.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/06.
//

import SwiftUI

struct OnDrag: ViewModifier {
	
	@Environment(\.isDragEnable) var isDragEnable
	@EnvironmentObject var myDispatchQueue: MyDispatchQueue
	
	let data: () -> NSItemProvider
	
	func body(content: Content) -> some View {
		if isDragEnable.wrappedValue {
			content.onDrag {
				isDragEnable.wrappedValue = false
//				print("Disable")
				myDispatchQueue.addDispatchTask(deadline: .now() + 10) {
					isDragEnable.wrappedValue = true
//					print("Enable")
				}
				return data()
			}
		}
		else {
			content
				.contextMenu {
					Button("Activer drag") {
						isDragEnable.wrappedValue = true
					}
				}
		}
	}
}


extension View {
	
	@ViewBuilder
	func onDrag(allowMulitpleSelection: Bool, _ data: @escaping () -> NSItemProvider) -> some View {
		if allowMulitpleSelection {
			self.onDrag(data)
		}
		else {
			self.modifier(OnDrag(data: data))
		}
	}

}

