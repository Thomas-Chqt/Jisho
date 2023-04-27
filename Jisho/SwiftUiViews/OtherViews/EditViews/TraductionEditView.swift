//
//  TraductionEditView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/22.
//

import SwiftUI

struct TraductionEditView: View {
	@EnvironmentObject var settings: Settings
	
	@ObservedObject var traduction: Traduction
	
	var existingLanguesInSense: Set<Langue>? = nil
	
	var selectableLangues: [Langue] {
		settings.orderedSelectedLangues.filter {
			!(existingLanguesInSense?.contains($0) ?? false)
		}
	}
	
    var body: some View {
		HStack {
			Menu {
				ForEach(selectableLangues) { langue in
					Button("\(langue.flag) \(langue.fullName)") {
						traduction.langue = langue
					}
				}
			} label: {
				Text("\(traduction.langue.flag)")
			}
			
			TextField("Traduction", text: $traduction.text)
		}
    }
}

struct TraductionEditView_Previews: PreviewProvider {
	static var previews: some View {
		wrappedView()
	}
	
	struct wrappedView: View {
		
		@State var showSheet: Bool = true
		@ObservedObject var sense = Sense(traductions: [ Traduction(langue: .francais, text: "trad fr"),
														 Traduction(langue: .anglais, text: "trad en")  ])
		
		var body: some View {
			Button("Show Sheet") {
				showSheet.toggle()
			}
			.sheet(isPresented: $showSheet) {
				NavigationStack {
					List {
						ForEach(sense.traductions.fitToSettings()) { trad in
							TraductionEditView(traduction: trad,
											   existingLanguesInSense: Set(sense.traductions.map{$0.langue}))
						}
					}
					.menuButton {
						Button("Rest settings") {
							Settings.shared.langueOrder = Settings.defaulLangueOrder
							Settings.shared.selectedLangues = Settings.defaulSselectedLangues
						}
					}
				}
			}
			.environmentObject(Settings.shared)
		}
	}
}
