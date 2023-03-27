//
//  DebugListRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/22.
//

import SwiftUI
import CoreData
import Combine

struct DebugListRowView<T: NSManagedObject>: View {
	@Environment(\.managedObjectContext) var viewContext
	@StateObject var vm = DebugListRowViewModel<T>()
	
	var objType: NSManagedObjectType
	
	var body: some View {
		NavigationLink(value: objType) {
			HStack {
				Text(objType.description)
				Spacer()
				Text("\(vm.objectCount)")
			}
		}
	}
}

struct DebugListRowView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List {
				DebugListRowView<MetaData>(objType: .metaData)
					.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
			}
			.listStyle(.plain)
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
    }
}
