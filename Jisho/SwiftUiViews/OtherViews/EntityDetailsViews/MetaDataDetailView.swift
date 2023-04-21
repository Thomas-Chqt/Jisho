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
		Group {
			if metaData is LinkMetaData {
				NavigationLink(value: nil as Int?) {
					label
				}
			}
			else {
				label
			}
		}
		.font(.caption)
		.padding(.vertical, 3.5)
		.padding(.horizontal, 10)
    }
	
	var label: some View {
		HStack(alignment: .top) {
			Image(systemName: "info.circle")
			Text(metaData.text)
		}
	}
}

struct MetaDataDetailView_Previews: PreviewProvider {
	
	static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			Text("")
				.navigationTitle("side")
		} detail: {
			List {
				MetaDataDetailView(CommunMetaData(.preview))
			}
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		
		
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List {
				MetaDataDetailView(CommunMetaData(.preview))
			}
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
	}
}
