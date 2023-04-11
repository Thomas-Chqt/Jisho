//
//  DebugEntityListWrapper.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/05.
//

import SwiftUI

struct DebugEntityListWrapper<T: Entity>: View where T: Displayable, T: EasyInit {
	@Environment(\.managedObjectContext) var context
	
	@FetchRequest(sortDescriptors: []) var entities: FetchedResults<T>
	
	@Binding var selection: Entity?
	
	var sortedEntities: [T] {
		entities.sorted {
			$0.id.uuidString > $1.id.uuidString
		}
	}
	
	
    var body: some View {
        ListDisplayableEntityView(selection: $selection,
								  entities: sortedEntities,
								  onDelete: delete)
			.menuButton {
				Button("Add one") {
					add(1)
				}
				Button("Add 1000") {
					add(1000)
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						add(1)
					} label: {
						Image(systemName: "plus")
					}
					
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
			sortedEntities[index].delete()
		}
		DataController.shared.save()
	}
}

struct DebugEntityListWrapper_Previews: PreviewProvider {
	
    static var previews: some View {
		NavigationStack {
			DebugEntityListWrapper<Mot>(selection: .constant(nil))
		}
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
    }
}
