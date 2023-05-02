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
	
	init(_ type: T.Type) { }
			
	var body: some View {
		HStack {
			Text(T.description())
			Spacer()
			Text("\(vm.objectCount)")
		}
	}
}

struct ManagedObjectDebugRowView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			NavigationStack {
				NavigationLink(value: 1) {
					ManagedObjectDebugRowView(Mot.self)
				}
			}
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
    }
}
