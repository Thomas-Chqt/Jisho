//
//  DebugListRowViewModel.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/22.
//

import Foundation
import CoreData
import Combine

class DebugListRowViewModel<T: NSManagedObject>: ObservableObject {
	@Published var objectCount: Int = 0
	
	private var viewContext = DataController.shared.mainQueueManagedObjectContext
	private let fetchRequest: NSFetchRequest<NSFetchRequestResult>
	private var cancellable: AnyCancellable?
	
	init() {
		fetchRequest = T.fetchRequest()
		setupSubscription()
		updateCount()
	}
	
	private func setupSubscription() {
		cancellable = NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewContext)
			.sink { [weak self] _ in
				self?.updateCount()
			}
	}
	
	private func updateCount() {
		do {
			objectCount = try viewContext.count(for: fetchRequest)
		} catch {
			print("Error fetching count: \(error.localizedDescription)")
			objectCount = 0
		}
	}
}
