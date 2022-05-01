//
//  ContentView.swift
//  Shared
//
//  Created by Thomas Choquet on 2022/02/16.
//

import SwiftUI


struct ContentView: View
{
    
    @CloudStorage("languesPrefData") var languesPref:[Langue] = languesPrefOriginal
    @CloudStorage("metaDataDictData") var metaDataDict:[MetaData : String?] = metaDataDictOriginal
    @CloudStorage("languesAfficheesData") var languesAffichées:Set<Langue> = languesAffichéesOriginal
    
    
    @State var sideMenuIsShow = false
    @State var currentPage:Page = .search
    
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View
    {
        TabView(selection: $currentPage) {
            
            NavigationView {
                SearchPageView()
                EmptyView()
            }
            .tag(Page.search)
            
            NavigationView {
                ListePageView()
                EmptyView()
            }
            .tag(Page.listes)
            
            NavigationView {
                SettingsPageView()
                EmptyView()
            }
            .tag(Page.settings)
            
            NavigationView {
                DebugMenu()
                EmptyView()
            }
            .tag(Page.debug)
        }
        .sideMenu(isPresented: $sideMenuIsShow, currentPage: $currentPage)
        .environment(\.toggleSideMenu, { withAnimation { sideMenuIsShow.toggle() } })
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
