//
//  SearchPageView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import SwiftUI

struct SearchPageView: View {
	@Environment(\.toggleSideMenu) var showSideMenu

    var body: some View {
		NavigationSplitView {
			NavigationLink("link") {
				Text("Dest")
			}
			.navigationTitle("Recherche")
			.showSideMenuButton(showSideMenu: showSideMenu)
			.menuButton {
				Button("1", action: {})
				Button("2", action: {})
				Button("3", action: {})
				Button("4", action: {})
			}
		} detail: {
			Text("Aucun mot selectionné")
		}
    }
}

struct SearchPageView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPageView()
    }
}
