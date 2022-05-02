//
//  ContentView.swift
//  Shared
//
//  Created by Thomas Choquet on 2022/02/16.
//

import SwiftUI

fileprivate class ContentViewModel: ObservableObject {
    
    // MARK: Publisher
    
    @Published var sideMenuIsShow = false
    @Published var currentPage:Page = .search
    
    
    // MARK: Computed Variables
    
    var searchPage: some View {
        NavigationView {
            SearchPageView()
            EmptyView()
        }
    }
    
    var listePage: some View {
        NavigationView {
            ListePageView()
            EmptyView()
        }
    }
    
    var settingsPage: some View {
        NavigationView {
            SettingsPageView()
            EmptyView()
        }
    }
    
    var debugPage: some View {
        NavigationView {
            DebugMenu()
            EmptyView()
        }
    }
    
    
    // MARK: Functions
    
    func toggleSideMenu() {
        withAnimation {
            sideMenuIsShow.toggle()
        }
    }
    
}

struct ContentView: View
{
    // Les property wrapper ne son pas dans la vm car ils ne fonctionnent pas comme des @Publised ( a modifer a term )
    
    @CloudStorage("languesPrefData") private var languesPref:[Langue] = languesPrefOriginal
    @CloudStorage("metaDataDictData") private var metaDataDict:[MetaData : String?] = metaDataDictOriginal
    @CloudStorage("languesAfficheesData") private var languesAffichées:Set<Langue> = languesAffichéesOriginal
    
    
    @StateObject private var vm = ContentViewModel()
    
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View
    {
        TabView(selection: $vm.currentPage) {
            
            vm.searchPage
                .tag(Page.search)
            
            vm.listePage
                .tag(Page.listes)
            
            vm.settingsPage
                .tag(Page.settings)
            
            vm.debugPage
                .tag(Page.debug)
        }
        .sideMenu(isPresented: $vm.sideMenuIsShow, currentPage: $vm.currentPage)
        .environment(\.toggleSideMenu, vm.toggleSideMenu)
        .environment(\.languesPref, _languesPref)
        .environment(\.languesAffichées, _languesAffichées)
        .environment(\.metaDataDict, _metaDataDict)
    }
}





//struct ContentView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        ContentView()
//    }
//}
