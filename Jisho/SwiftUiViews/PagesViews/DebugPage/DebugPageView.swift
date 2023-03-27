//
//  DebugPageView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/21.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct DebugPageView: View {
	@Environment(\.toggleSideMenu) var showSideMenu
	@StateObject var vm = DebugPageViewModel()
	
    var body: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List(selection: $vm.selection) {
				DebugListRowView<MetaData>(objType: .metaData)
			}
			.fileExporter(isPresented: $vm.showFileExporter,
						  document: vm.fileExporterContent.document,
						  contentType: vm.fileExporterContent.type,
						  defaultFilename: vm.fileExporterContent.filename,
						  onCompletion: vm.fileExporterContent.completion)
			.listStyle(.plain)
			.navigationTitle("Debug")
			.showSideMenuButton(showSideMenu: showSideMenu)
			.menuButton {
				Button("Export SQLite file", action: vm.exportSQLiteFile)
				Button("Export SQLite-shm file", action: vm.exportSQLiteSHMFile)
				Button("Export SQLite-wal file", action: vm.exportSQLiteWALFile)

			}
		}
		detail: {
			if let selection = vm.selection {
				DebugPageDetailView(objType: selection)
			}
			else {
				Text("")
			}
		}
		.navigationSplitViewStyle(.balanced)

    }
}

struct DebugPageView_Previews: PreviewProvider {
    static var previews: some View {
		DebugPageView()
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
    }
}
