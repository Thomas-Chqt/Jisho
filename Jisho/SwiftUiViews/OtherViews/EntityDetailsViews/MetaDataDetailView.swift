//
//  MetaDataDetailView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/05.
//

import SwiftUI

struct MetaDataDetailView: View {
	
	@ObservedObject var metaData: MetaData
	
	init(_ metaData: MetaData) {
		self.metaData = metaData
	}
	
    var body: some View {
		HStack(alignment: .top) {
			Image(systemName: "info.circle")
			Text(metaData.text ?? "")
		}
		.font(.caption)
		.padding(.vertical, 3.5)
		.padding(.horizontal, 10)
    }
}

struct MetaDataDetailView_Previews: PreviewProvider {
	
	static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			Text("")
				.navigationTitle("side")
		} detail: {
			List {
				MetaDataDetailView(MetaData(.preview))
			}
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		
		
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List {
				MetaDataDetailView(MetaData(.preview))
			}
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
	}
}
