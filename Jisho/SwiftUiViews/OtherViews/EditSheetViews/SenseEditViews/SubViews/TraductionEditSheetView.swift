//
//  TraductionEditSheetView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/06.
//

import SwiftUI

struct TraductionEditSheetView: View {
	
	@EnvironmentObject var settings: Settings
	
	@ObservedObject var traduction: Traduction
	
	var excludeLangue: [Langue]?
	
	var textBinding: Binding<String> {
		Binding {
			traduction.text ?? ""
		} set: {
			traduction.text = $0
		}

	}
	
	var selectableLangue: [Langue] {
		guard let excludeLangue = excludeLangue else {
			return Langue.orderedSelected.filter {
				$0 != traduction.langue
			} + (traduction.langue != .none ? [.none] : [])
			
		}
		return Langue.orderedSelected.filter {
			!excludeLangue.contains($0)
		}.filter {
			$0 != traduction.langue
		} + (traduction.langue != .none ? [.none] : [])
	}
	
	init(traduction: Traduction, excludeLangue: [Langue]? = nil) {
		self.traduction = traduction
		self.excludeLangue = excludeLangue
	}

	
    var body: some View {
		HStack {
			Menu {
				ForEach(selectableLangue) { langue in
					Button("\(langue.flag) \(langue.fullName)") {
						traduction.parentObjectWillChange().send()
						traduction.langue = langue
					}
				}
			} label: {
				Text("\(traduction.langue.flag)")
			}

			TextField("Traduction", text: textBinding)
		}
	}
}

struct TraductionEditSheetView_Previews: PreviewProvider {
		
    static var previews: some View {
		wrappedView()
    }
	
	struct wrappedView: View {
		
		@State var showSheet: Bool = true
				
		var body: some View {
			Button("Show Sheet") {
				showSheet.toggle()
			}
			.sheet(isPresented: $showSheet) {
				NavigationStack {
					List {
						TraductionEditSheetView(traduction: Traduction(.preview), excludeLangue: nil)
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



