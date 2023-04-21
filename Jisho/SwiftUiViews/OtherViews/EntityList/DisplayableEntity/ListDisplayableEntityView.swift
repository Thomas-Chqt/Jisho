//
//  DisplayableEntityListView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/03.
//

import SwiftUI

struct ListDisplayableEntityView<T: Entity>: View where T: Displayable {
	
	@Binding var selection: Entity?
	var entities: [T]
	var onDelete: ((IndexSet) -> Void)? = nil
	
    var body: some View {
		List(selection: $selection) {
			ForEach(entities) { entity in
				NavigationLink(value: entity) {
					RowDisplayableEntityView(entity)
				}
			}
			.onDelete(perform: onDelete)
		}
		.listStyle(.plain)
    }
}

struct DisplayableEntityListView_Previews: PreviewProvider {
	
	static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			ListDisplayableEntityView(selection: .constant(nil),
									  entities: [ Mot(.preview), Mot(.preview) ])
			.navigationTitle("List")
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
	}
}
