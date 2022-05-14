//
//  SettingsPageView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/19.
//

import SwiftUI

struct SettingsPageView: View{
    
    @Environment(\.toggleSideMenu) var showSideMenu

    
    var body: some View
    {
        List
        {
            NavigationLink("Meta datas", destination: MetaDatasEditorView())
            NavigationLink("Langues", destination: LanguesAffiche_View())
            NavigationLink("Debug", destination: DebugMenu())
        }
        .listStyle(.plain)
        .navigationTitle("Paramètres")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showSideMenu()
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationView {
            SettingsPageView()
        }
    }
}
