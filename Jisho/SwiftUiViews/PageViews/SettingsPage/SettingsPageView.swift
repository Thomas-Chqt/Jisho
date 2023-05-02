//
//  SettingsPageView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/07.
//

import SwiftUI

struct SettingsPageView: View {
	
	@StateObject var navModel = SettingsPageNavigationModel()
	
    var body: some View {
//		NavigationSplitView(columnVisibility: .constant(.all)) {
//			List(selection: $navModel.selection) {
//				NavigationLink("Langues", value: SettingsPageSelection.languesSettings)
//			}
//			.listStyle(.plain)
//			.navigationTitle(AppPages.settings.fullName)
//			.showSideMenuButton()
//		} detail: {
//			navModel.selection?.view
//				.showSideMenuButton()
//		}
//		.navigationSplitViewStyle(.balanced)
		
		
		
//		NavigationStack {
//			List {
//				NavigationLink("Langues", value: SettingsPageSelection.languesSettings)
//			}
//			.navigationDestination(for: SettingsPageSelection.self) { selection in
//				switch selection {
//				case .languesSettings:
//					LanguesSettingsView()
//				}
//			}
//		}
		
		
		NavigationSplitView {
			List {
				NavigationLink("Langues") {
					LanguesSettingsView().showSideMenuButton()
				}
			}
			.listStyle(.plain)
			.navigationTitle(AppPages.settings.fullName)
			.showSideMenuButton()
		} detail: {
			
		}
    }
}

struct SettingsPageView_Previews: PreviewProvider {
	
    static var previews: some View {
		SettingsPageView()
			.environmentObject(Settings.shared)
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
    }
	
}


