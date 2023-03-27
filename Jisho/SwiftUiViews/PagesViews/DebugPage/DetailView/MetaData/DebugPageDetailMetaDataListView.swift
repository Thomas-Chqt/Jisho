//
//  DebugPageDetailMetaDataListView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/22.
//

import SwiftUI

struct DebugPageDetailMetaDataListView: View {
	
	@Environment(\.managedObjectContext) var viewContext
	@FetchRequest(sortDescriptors: []) var metaDatas: FetchedResults<MetaData>
	
	var sortedMetaDatas: [MetaData] {
		metaDatas.sorted(by: {$0.ID.uuidString > $1.ID.uuidString})
	}
	
    var body: some View {
		List {
			ForEach(sortedMetaDatas) { metaData in
				DebugPageDetailMetaDataListRowView(metaData: metaData)
			}
			.onDelete(perform: deleteMetaData)
		}
		.listStyle(.plain)
		.menuButton {
			Button("Add 1000", action: add1000metaData)
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: addMetaData) {
					Image(systemName: "plus")
				}
			}
		}

    }
	
	
	func deleteMetaData(indexSet: IndexSet)  {
		for index in indexSet {
			viewContext.delete(metaDatas[index])
			try! viewContext.save()
		}
	}
	
	func addMetaData() {
		_ = MetaData(.preview)
		
		do {
			try viewContext.save()
		} catch {
			print("Error save")
		}
		
	}
	
	func add1000metaData() {
		for _ in 1...1000 {
			_ = MetaData(.preview)
		}
		
		do {
			try viewContext.save()
		} catch {
			print("Error save")
		}
	}
}

struct DebugPageDetailMetaDataListView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List(selection: .constant("")) {
				EmptyView()
			}
		} detail: {
			DebugPageDetailView(objType: .metaData)
				.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		}
		.navigationSplitViewStyle(.balanced)
	}
}
