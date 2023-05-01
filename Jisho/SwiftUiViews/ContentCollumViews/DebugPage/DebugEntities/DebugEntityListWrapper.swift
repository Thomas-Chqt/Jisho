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
	
	@Binding var selection: DetailCollumRoot?
	
	
	init(type: T.Type, selection: Binding<DetailCollumRoot?>) {
		self._selection = selection
		let request = NSFetchRequest<T>(entityName: T.description())
		request.fetchLimit = 1000
		request.sortDescriptors = [ NSSortDescriptor(key: "createTime_atb", ascending: true) ]
		self._entities = FetchRequest(fetchRequest: request, animation: .default)
	}
	
    var body: some View {
		List(selection: $selection) {
			ForEach(entities) { entity in
				NavigationLink(value: DetailCollumRoot.entity(entity)) {
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
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: 	{ add(1) },
					   label: 	{ Image(systemName: "plus") })
			}
		}
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
//			if selection == DetailCollumRoot.entity(entities[index]) { selection = nil }
			selection = nil
			entities[index].delete()
		}
		DataController.shared.save()
	}
}

struct DebugEntityListWrapper_Previews: PreviewProvider {
	
    static var previews: some View {
		WrappedView()
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
			.environmentObject(Settings.shared)

    }
	
	struct WrappedView: View {
		
		@StateObject var navModel = NavigationModel()
		
		var body: some View {
			NavigationSplitView(columnVisibility: .constant(.all)) {
				EmptyView()
			} content: {
				NavigationStack {
					DebugEntityListWrapper(type: Mot.self, selection: $navModel.detailCollumRoot)
				}
			} detail: {
				EmptyView()
			}
		}
	}
}
