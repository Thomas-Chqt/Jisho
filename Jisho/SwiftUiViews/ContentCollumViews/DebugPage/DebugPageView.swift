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
	
	@StateObject var vm = DebugPageViewModel()
	
	@Binding var selection: DetailCollumRoot?
		
    var body: some View {
		List {
			Section("Entities") {
				NavigationLink(value: 1) { ManagedObjectDebugRowView(Mot.self) }
				NavigationLink(value: 2) { ManagedObjectDebugRowView(Japonais.self) }
				NavigationLink(value: 3) { ManagedObjectDebugRowView(Sense.self) }
				NavigationLink(value: 4) { ManagedObjectDebugRowView(Traduction.self) }
				NavigationLink(value: 5) { ManagedObjectDebugRowView(CommunMetaData.self) }
			}
			Section("JMdict") {
				NavigationLink("JMdict debug", value: 6)
			}
			Section("Settings") {
				Text("Reset Settings").clickable {
					Settings.shared.selectedLangues = Settings.defaulSselectedLangues
					Settings.shared.langueOrder = Settings.defaulLangueOrder
					print("Reset")
				}
			}
		}
		.listStyle(.plain)
		.fileExporter(vm)
		.menuButton {
			Button("Export SQLite file", action: vm.exportSQLiteFile)
			Button("Export SQLite-shm file", action: vm.exportSQLiteSHMFile)
			Button("Export SQLite-wal file", action: vm.exportSQLiteWALFile)
			Button("Reset CoreData", action: vm.resetCoreData)
		}
		.navigationTitle("Debug")
		
		.navigationDestination(for: Int.self) { nbr in
			switch nbr {
				case 1:	DebugEntityListWrapper(type: Mot.self, 				selection: $selection)
				case 2: DebugEntityListWrapper(type: Japonais.self, 		selection: $selection)
				case 3: DebugEntityListWrapper(type: Sense.self, 			selection: $selection)
				case 4:	DebugEntityListWrapper(type: Traduction.self, 		selection: $selection)
				case 5: DebugEntityListWrapper(type: CommunMetaData.self,	selection: $selection)
				case 6: JMdictDebugView()
				default: EmptyView()
			}
		}
	}
}

struct DebugPageView_Previews: PreviewProvider {
    static var previews: some View {
		WrappedView()
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
			.environmentObject(Settings.shared)
    }
	
	struct WrappedView: View {
		
		@StateObject var navModel = NavigationModel()
		
		var body: some View {
			NavigationSplitView(columnVisibility: .constant(.all)) {
				EmptyView()
			} content: {
				NavigationStack(path: $navModel.contentCollumNavigationPath){
					DebugPageView(selection: $navModel.detailCollumRoot)
				}
			} detail: {
				EmptyView()
			}
		}
	}
}
