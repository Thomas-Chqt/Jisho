//
//  DebugPageDetailView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/22.
//

import SwiftUI

struct DebugPageDetailView: View {
	
	var objType: NSManagedObjectType
	
    var body: some View {
		Group {
			switch objType {
			case .metaData:
				DebugPageDetailMetaDataListView()
			}
		}
		.navigationTitle(objType.description)
    }
}

struct DebugPageDetailView_Previews: PreviewProvider {
    static var previews: some View {
		
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List(selection: .constant("")) {
				EmptyView()
			}
			.listStyle(.plain)
		} detail: {
			DebugPageDetailView(objType: .metaData)
				.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		}
		.navigationSplitViewStyle(.balanced)
    }
}
