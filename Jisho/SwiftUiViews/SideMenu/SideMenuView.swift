//
//  SideMenuView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/17.
//

import SwiftUI

struct SideMenuView: View {
	
	var size: SideMenuSize
	
    var body: some View {
		ZStack {
			Rectangle()
				.ignoresSafeArea()
			List {
				Section("Recherche") {
					SideMenuButtonView(size: size, page: .searchJap)
					SideMenuButtonView(size: size, page: .searchTrad)
					SideMenuButtonView(size: size, page: .searchExemple)
				}
				Section("Autres") {
					SideMenuButtonView(size: size, page: .listes)
					SideMenuButtonView(size: size, page: .settings)
					SideMenuButtonView(size: size, page: .debug)
				}
			}
			.environment(\.defaultMinListRowHeight, 0)
			.environment(\.defaultMinListHeaderHeight, 0)
			.listStyle(.inset)
		}
		.frame(width: size.rawValue)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
			.sideMenu(isPresented: .constant(true), size: .big, currentPage: .constant(.searchJap))
    }
}
