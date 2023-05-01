//
//  SettingsPageView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/07.
//

import SwiftUI

struct SettingsPageView: View {
	
	@Binding var selection: DetailCollumRoot?
	
    var body: some View {
		List(selection: $selection) {
			NavigationLink("Langue", value: DetailCollumRoot.langueSettings)
		}
		.listStyle(.plain)
		.navigationTitle("Réglages")
    }
}

struct SettingsPageView_Previews: PreviewProvider {
	
    static var previews: some View {
        WrappedView()
			.environmentObject(Settings.shared)
    }
	
	struct WrappedView: View {
		
		@StateObject var navModel = NavigationModel()

		var body: some View {
			NavigationSplitView(columnVisibility: .constant(.all)) {
				EmptyView()
			} content: {
				NavigationStack(path: $navModel.contentCollumNavigationPath){
					SettingsPageView(selection: $navModel.detailCollumRoot)
				}
			} detail: {
				EmptyView()
			}
		}
	}
}


