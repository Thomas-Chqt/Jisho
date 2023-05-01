//
//  ContentView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import SwiftUI


struct ContentView: View {
	
	@StateObject var navModel = NavigationModel()
	
	var body: some View {
		NavigationSplitView(columnVisibility: $navModel.columnVisibility) {
			SideBarView(selection: navModel.sideMenuSelection)
				.navigationSplitViewColumnWidth(170)
		} content: {
			NavigationStack(path: $navModel.contentCollumNavigationPath){
				navModel.contentCollumRoot?.view(selection: $navModel.detailCollumRoot)
			}
			.navigationSplitViewColumnWidth(300)
		} detail: {
			NavigationStack(path: $navModel.detailCollumNavigationPath) {
				navModel.detailCollumRoot?.view
			}
		}
	}
}

struct ContentView_iOS_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
			.environmentObject(Settings.shared)
    }
}

