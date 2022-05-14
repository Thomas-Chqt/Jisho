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
    
    
    // MARK: Functions
    
    func toggleSideMenu() {
        withAnimation {
            sideMenuIsShow.toggle()
        }
    }
    
}

struct ContentView: View
{
    @StateObject private var vm = ContentViewModel()
    
    
    init() { UITabBar.appearance().isHidden = true }
    
    var body: some View
    {
        TabView(selection: $vm.currentPage) {
            
            vm.searchPage
                .tag(Page.search)
            
            vm.listePage
                .tag(Page.listes)
            
            vm.settingsPage
                .tag(Page.settings)
        }
        .sideMenu(isPresented: $vm.sideMenuIsShow, currentPage: $vm.currentPage)
        .environment(\.toggleSideMenu, vm.toggleSideMenu)
    }
}





//struct ContentView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        ContentView()
//    }
//}
