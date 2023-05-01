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
		WrappedView()
			.navigationSplitViewStyle(.balanced)
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
    }
	
	struct WrappedView: View {
		
		@StateObject var navModel = NavigationModel()
		
		var body: some View {
			NavigationSplitView(columnVisibility: .constant(.all)) {
				EmptyView()
			} content: {
				NavigationStack(path: $navModel.contentCollumNavigationPath){
					NavigationLink(value: 1) {
						ManagedObjectDebugRowView(Mot.self)
					}
				}
			} detail: {
				EmptyView()
			}
		}
	}
}
