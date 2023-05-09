//
//  ContentView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import SwiftUI


struct ContentView: View {
	
	@State var sideMenuIsShow = false
	@State var currentPage: AppPages = .listes
	
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		WrappedView()
    }
	
	struct WrappedView: View {
		
		@StateObject private var dataController = DataController.shared
		@StateObject private var settings = Settings.shared
		@State var isDragEnable = true
		@StateObject var myDispatchQueue = MyDispatchQueue()
		
		var body: some View {
			ContentView()
				.environment(\.managedObjectContext, dataController.mainQueueManagedObjectContext)
				.environmentObject(settings)
				.environment(\.isDragEnable, $isDragEnable)
				.environmentObject(myDispatchQueue)
		}
	}
}
