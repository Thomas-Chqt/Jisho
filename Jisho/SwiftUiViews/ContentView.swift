//
//  ContentView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import SwiftUI


struct ContentView: View {
	
	@StateObject var vm = ContentViewModel()
	
	init() { UITabBar.appearance().isHidden = true }
	
	var body: some View {
		TabView(selection: $vm.currentPage) {
			
			SearchPageView()
				.tag(AppPage.searchJap)
			
			SearchPageView()
				.tag(AppPage.searchTrad)
			
			SearchPageView()
				.tag(AppPage.searchExemple)
			
//			Text(AppPage.listes.fullName)
//				.tag(AppPage.listes);
//
			SettingsPageView()
				.tag(AppPage.settings);
			
			DebugPageView()
				.tag(AppPage.debug);
		}
		.sideMenu(isPresented: $vm.sideMenuIsShow, currentPage: $vm.currentPage)
		.environment(\.toggleSideMenu, vm.toggleSideMenu)
		.environment(\.switchPage, vm.switchPage)
	}
}

struct ContentView_iOS_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
    }
}
