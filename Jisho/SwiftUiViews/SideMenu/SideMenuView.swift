//
//  SideMenuView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/18.
//

import SwiftUI
import CoreData


struct SideMenuView: View
{
    @Environment(\.switchPage) var switchPage
    @Environment(\.toggleSideMenu) var dismiss


    var body: some View
    {
        
        VStack(alignment: .leading, spacing: 0) {
            
            SideMenuButtonView(icone: Image(systemName: "magnifyingglass"), text: "Recherche") {
                switchPage(.search)
            }
            
            Divider().frame(width: 250)
            
            SideMenuButtonView(icone: Image(systemName: "list.bullet.rectangle.portrait"), text: "Listes") {
                switchPage(.listes)
            }
            
            Divider().frame(width: 250)
            
            SideMenuButtonView(icone: Image(systemName: "gearshape"), text: "Paramètres") {
                switchPage(.settings)
            }
            
            /*
            Divider().frame(width: 250)

            SideMenuButtonView(icone: Image(systemName: "wrench"),
                               text: "Debug action") {

                DataController.shared.container.performBackgroundTask { context in
                    _ = Mot(odre: 0,
                            japonais: [Japonais(ordre: 0, kanji: "Bite", kana: "Zizi", context: context)],
                            context: context)
                    
                    try! context.save()
                }

            }
             */
             
        }
        .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.primary.opacity(0.5), lineWidth: 1))
    }
}



/*
struct SideMenuView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(.black.opacity(0.2)).ignoresSafeArea()
            
            SideMenuView()
                .offset(x: 10, y: 10)
        }
    }
}
*/
