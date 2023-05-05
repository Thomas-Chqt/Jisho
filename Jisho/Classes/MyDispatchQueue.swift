//
//  MyDispatchQueue.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/06.
//

import SwiftUI

class MyDispatchQueue: ObservableObject {
	@Published var createdDispatchTask: [DispatchWorkItem] = []
	
	func addDispatchTask(deadline: DispatchTime, _ action: @escaping () -> Void) {
		let newDispatchWorkItem = DispatchWorkItem(block: action)
		createdDispatchTask.append(newDispatchWorkItem)
		DispatchQueue.main.asyncAfter(deadline: deadline, execute: newDispatchWorkItem)
	}
	
	func removeAllDispatchWorkItem() {
		for task in createdDispatchTask {
			task.cancel()
		}
		createdDispatchTask = []
	}
}
