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
	@StateObject var navModel = DebugPageNavigationModel()
	
    var body: some View {
		NavigationSplitView {
			NavigationStack {
				List(selection: $navModel.selection) {
					Section("Entities") {
						NavigationLink(value: 1) { ManagedObjectDebugRowView(Mot.self) }
						NavigationLink(value: 2) { ManagedObjectDebugRowView(Japonais.self) }
						NavigationLink(value: 3) { ManagedObjectDebugRowView(Sense.self) }
						NavigationLink(value: 4) { ManagedObjectDebugRowView(Traduction.self) }
						NavigationLink(value: 5) { ManagedObjectDebugRowView(CommunMetaData.self) }
					}
					Section("JMdict") {
						NavigationLink("JMdict debug", value: DebugPageSelection.JMdictDebug)
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
				.navigationDestination(for: Int.self) { nbr in
					switch nbr {
						case 1:	DebugEntityListWrapper(type: Mot.self, 				selection: $navModel.selection).showSideMenuButton()
						case 2: DebugEntityListWrapper(type: Japonais.self, 		selection: $navModel.selection).showSideMenuButton()
						case 3: DebugEntityListWrapper(type: Sense.self, 			selection: $navModel.selection).showSideMenuButton()
						case 4:	DebugEntityListWrapper(type: Traduction.self, 		selection: $navModel.selection).showSideMenuButton()
						case 5: DebugEntityListWrapper(type: CommunMetaData.self,	selection: $navModel.selection).showSideMenuButton()
						case 6: JMdictDebugView()
						default: EmptyView()
					}
				}
				.navigationTitle(AppPages.debug.fullName)
				.fileExporter(vm)
				.menuButton {
					Button("Export SQLite file", action: vm.exportSQLiteFile)
					Button("Export SQLite-shm file", action: vm.exportSQLiteSHMFile)
					Button("Export SQLite-wal file", action: vm.exportSQLiteWALFile)
					Button("Reset CoreData", action: vm.resetCoreData)
				}
				.showSideMenuButton()
			}
		} detail: {
			navModel.selection?.view
				.showSideMenuButton()
		}

	}
}

struct DebugPageView_Previews: PreviewProvider {
    static var previews: some View {
		DebugPageView()
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
			.environmentObject(Settings.shared)
    }
}
