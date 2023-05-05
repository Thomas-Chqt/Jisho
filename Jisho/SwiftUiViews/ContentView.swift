//
//  ContentView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import SwiftUI


struct ContentView: View {
	
	@State var sideMenuIsShow = false
	@State var currentPage: AppPages = .debug
	
	init() { UITabBar.appearance().isHidden = true }
	
	var body: some View {
		TabView(selection: $currentPage) {
			RootListePageView().tag(AppPages.listes)
			SettingsPageView().tag(AppPages.settings)
			DebugPageView().tag(AppPages.debug)
		}
		.sideMenu(currentPage: $currentPage, isPresented: $sideMenuIsShow)
	}
}

struct ContentView_iOS_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
			.environmentObject(Settings.shared)
    }
}

