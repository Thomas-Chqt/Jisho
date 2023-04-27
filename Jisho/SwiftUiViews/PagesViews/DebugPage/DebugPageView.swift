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
			NavigationStack {
				List {
					Section("Entities") {
						ManagedObjectDebugRowView<Mot>()
						ManagedObjectDebugRowView<Japonais>()
						ManagedObjectDebugRowView<Sense>()
						ManagedObjectDebugRowView<Traduction>()
						ManagedObjectDebugRowView<CommunMetaData>()
					}
					Section("Settings") {
						Text("Reset Settings").clickable {
							Settings.shared.selectedLangues = Settings.defaulSselectedLangues
							Settings.shared.langueOrder = Settings.defaulLangueOrder
							print("Reset")
						}
					}
					Section("JMdict") {
						NavigationLink("JMdict debug", value: 1)
					}
				}
				.navigationDestination(for: CoreDataEntityType.self) { type in
					switch type {
					case .mot(_):
						DebugEntityListWrapper<Mot>(selection: $vm.selection)
					case .japonais(_):
						DebugEntityListWrapper<Japonais>(selection: $vm.selection)
					case .sense(_):
						DebugEntityListWrapper<Sense>(selection: $vm.selection)
					case .traduction(_):
						DebugEntityListWrapper<Traduction>(selection: $vm.selection)
					case .metaData(_):
						DebugEntityListWrapper<CommunMetaData>(selection: $vm.selection)
					default:
						EmptyView()
					}
				}
				.navigationDestination(for: Int.self) { nbr in
					if nbr == 1 {
						JMdictSettingsView()
					}
				}
				.fileExporter(vm)
				.listStyle(.plain)
				.navigationTitle("Debug")
				.showSideMenuButton(showSideMenu: showSideMenu)
				.menuButton {
					Button("Export SQLite file", action: vm.exportSQLiteFile)
					Button("Export SQLite-shm file", action: vm.exportSQLiteSHMFile)
					Button("Export SQLite-wal file", action: vm.exportSQLiteWALFile)
					Button("Reset CoreData", action: vm.resetCoreData)
				}
			}
		}
		detail: {
			if let mot = vm.selection as? Mot {
				MotDetailView(mot)
			}
			if let japonais = vm.selection as? Japonais {
				List {
					JaponaisDetailsView(japonais)
				}
			}
			if let sense = vm.selection as? Sense {
				List {
					SenseDetailView(sense)
				}
			}
			if let metaData = vm.selection as? CommunMetaData {
				List {
					MetaDataDetailView(metaData)
				}
			}
			if let traduction = vm.selection as? Traduction {
				List {
					TraductionDetailView(traduction)
				}
			}
			else {
				EmptyView()
			}
		}
		.navigationSplitViewStyle(.balanced)

    }
}

struct DebugPageView_Previews: PreviewProvider {
    static var previews: some View {
		DebugPageView()
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
			.environmentObject(Settings.shared)
    }
}
