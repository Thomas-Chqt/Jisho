//
//  DropDestination.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/06.
//

import SwiftUI

struct ForEachWithDropDestination<Data: RandomAccessCollection, Content: View, T: Transferable>: DynamicViewContent where Data.Element : Identifiable {
	
	@Environment(\.isDragEnable) var isDragEnable
	@EnvironmentObject var myDispatchQueue: MyDispatchQueue
	
	var data: Data
	var content: (Data.Element) -> Content
	var action: ([T], Int) -> Void
	
	init(_ data: Data, action: @escaping ([T], Int) -> Void, content: @escaping (Data.Element) -> Content) {
		self.data = data
		self.content = content
		self.action = action
	}
	
	var body: some View {
		ForEach(data) { element in
			self.content(element)
		}
		.dropDestination(for: T.self) {
			isDragEnable.wrappedValue = true
//			print("Enable")
			myDispatchQueue.removeAllDispatchWorkItem()
			return action($0, $1)
		}
	}
}

struct DropDestination<T : Transferable>: ViewModifier {
	
	@Environment(\.isDragEnable) var isDragEnable
	@EnvironmentObject var myDispatchQueue: MyDispatchQueue
	
	var action: ([T], CGPoint) -> Bool
	var isTargeted: (Bool) -> Void
	
	init(for payloadType: T.Type = T.self,
		 action: @escaping ([T], CGPoint) -> Bool,
		 isTargeted: @escaping (Bool) -> Void = { _ in }) {
		self.action = action
		self.isTargeted = isTargeted
	}
	
	func body(content: Content) -> some View {
		content
			.dropDestination(for: T.self, action: {
				isDragEnable.wrappedValue = true
//				print("Enable")
				myDispatchQueue.removeAllDispatchWorkItem()
				return action($0, $1)
			}, isTargeted: isTargeted)
	}
}


extension View {
	
	@ViewBuilder
	func dropDestination<T>(shouldReEnableDrag: Bool, for payloadType: T.Type = T.self, action: @escaping ([T], CGPoint) -> Bool, isTargeted: @escaping (Bool) -> Void = { _ in }) -> some View where T : Transferable {
		if shouldReEnableDrag {
			self.modifier(DropDestination(for: payloadType, action: action, isTargeted: isTargeted))
		}
		else {
			self.dropDestination(for: payloadType, action: action, isTargeted: isTargeted)
		}
	}
}
