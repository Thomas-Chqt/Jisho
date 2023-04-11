//
//  SettingsPageView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/07.
//

import SwiftUI

struct SettingsPageView: View {
    var body: some View {
		NavigationStack {
			List {
				NavigationLink("Langues") {
					LanguesSettingsView()
				}
			}
			.navigationTitle(AppPage.settings.fullName)
			.showSideMenuButton()
		}
    }
}

struct SettingsPageView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPageView()
    }
}
