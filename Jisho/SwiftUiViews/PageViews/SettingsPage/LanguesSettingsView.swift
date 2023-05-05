//
//  LanguesSettingsView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/07.
//

import SwiftUI

struct LanguesSettingsView: View {
	
	@EnvironmentObject var settings: Settings
	
    var body: some View {
		List(selection: $settings.selectedLangues) {
			ForEach(settings.langueOrder, id: \.self) { langue in
				Text("\(langue.flag) \(langue.fullName)")
			}
			.onMove(perform: move)			
		}
		.environment(\.editMode, .constant(.active))
		.navigationTitle("Langues")
    }
	
	func move(from source: IndexSet, to destination: Int) {
		settings.langueOrder.move(fromOffsets: source, toOffset: destination)
	}
}

struct LanguesSettingsView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			LanguesSettingsView()
		}
		.environmentObject(Settings.shared)
    }
}
