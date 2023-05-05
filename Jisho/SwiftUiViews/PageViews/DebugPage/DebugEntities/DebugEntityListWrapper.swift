//
//  DebugEntityListWrapper.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/05.
//

import SwiftUI
import CoreData

struct DebugEntityListWrapper<T: Entity>: View where T: Displayable, T: EasyInit {
	@Environment(\.managedObjectContext) var context
	
	@FetchRequest(sortDescriptors: []) var entities: FetchedResults<T>
	
	@Binding var selection: DebugPageSelection?
	
	
	init(type: T.Type, selection: Binding<DebugPageSelection?>) {
		self._selection = selection
		let request = NSFetchRequest<T>(entityName: T.description())
		request.fetchLimit = 1000
		request.sortDescriptors = [ NSSortDescriptor(key: "createTime_atb", ascending: true) ]
		self._entities = FetchRequest(fetchRequest: request, animation: .default)
	}
	
    var body: some View {
		List(selection: $selection) {
			ForEach(entities) { entity in
				NavigationLink(value: DebugPageSelection.entity(entity)) {
					VStack(alignment: .leading) {
						Text(entity.primary ?? "")
						Text(entity.secondary ?? " ")
						Text(entity.details ?? " ")
					}
				}
			}
			.onDelete(perform: delete)
		}
		.listStyle(.plain)
		
		.menuButton {
			Button("Add one")	{ add(1) }
			Button("Add 1000")	{ add(1000)
			}
		}
		.addButton(add)
		.navigationTitle("All \(T.description())")
    }
	
	func add(_ n: Int) {
		for _ in 1...n {
			_ = T(.preview, context: context)
		}
		DataController.shared.save()
	}
	
	func delete(_ indexSet: IndexSet) {
		indexSet.forEach { index in
			if selection == DebugPageSelection.entity(entities[index]) { selection = nil }
			selection = nil
			entities[index].delete()
		}
		DataController.shared.save()
	}
}

struct DebugEntityListWrapper_Previews: PreviewProvider {
	
    static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			NavigationStack {
				DebugEntityListWrapper(type: Mot.self, selection: .constant(nil))
					.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
					.environmentObject(Settings.shared)
			}
		} detail: {
			EmptyView()
		}
    }
}
