//
//  DebugListRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/22.
//

import SwiftUI
import CoreData
import Combine

struct ManagedObjectDebugRowView<T: NSManagedObject>: View {
	@Environment(\.managedObjectContext) var viewContext
	@StateObject var vm = ManagedObjectDebugRowViewModel<T>()
			
	var body: some View {
		NavigationLink(value: CoreDataEntityType(T.description())){
			HStack {
				Text(T.description())
				Spacer()
				Text("\(vm.objectCount)")
			}
		}
	}
}

struct ManagedObjectDebugRowView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List {
				ManagedObjectDebugRowView<CommunMetaData>()
			}
			.listStyle(.plain)
			.navigationTitle("Title")
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
    }
}
