//
//  DisplayableEntityRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/28.
//

import SwiftUI

struct RowDisplayableEntityView<T: ObservableObject>: View where T: Displayable {
	
	@EnvironmentObject var settings: Settings
	
	var compact: Bool
	
	@StateObject var entity: T
	
	init(_ entity: T, compact: Bool = false) {
		self.compact = compact
		self._entity = StateObject(wrappedValue: entity)
	}
	
    var body: some View {
		if compact {
			compacted
		}
		else {
			fullSize
		}
    }
	
	var compacted: some View {
		VStack(alignment: .leading) {
			Text(entity.primary ?? "")
		}
	}
	
	var fullSize: some View {
		VStack(alignment: .leading) {
			Text(entity.primary ?? "")
			Text(entity.secondary ?? " ")
			Text(entity.details ?? " ")
		}
	}
}

struct DisplayableEntityRowView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			List {
				NavigationLink(value: "") {
					RowDisplayableEntityView(Mot(.preview))
				}
			}
			.listStyle(.plain)
			.navigationTitle("List")
		}
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)

		
		NavigationStack {
			List {
				NavigationLink(value: "") {
					RowDisplayableEntityView(Mot(.preview), compact: true)
				}
			}
			.listStyle(.plain)
			.navigationTitle("List")
		}
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		.environmentObject(Settings.shared)
		
    }
}
