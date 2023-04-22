//
//  MotDetailView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/04.
//

import SwiftUI

struct MotDetailView: View {
	
	@FocusState var notesIsFocused: Bool
	
	@ObservedObject var mot: Mot
	@State var showSheet: Bool = false
	
	init(_ mot: Mot) {
		self.mot = mot
	}
	
    var body: some View {
		List {
			Section("Japonais") {
				ForEach(mot.japonais) { jap in
					JaponaisDetailsView(jap)
				}
			}
			
			ForEach(Array(mot.senses.enumerated()), id: \.element) { index, sense in
				Section("Sense \(index + 1)") {
					SenseDetailView(sense)
				}
			}
			TextField("Notes", text: $mot.notes, axis: .vertical)
				.focused($notesIsFocused)
				.lineLimit(3...)
				.onSubmit {
					mot.notes += "\n"
					notesIsFocused = true
				}
		}
		.scrollDismissesKeyboard(.interactively)
		.navigationBarTitleDisplayMode(.inline)
		.listStyle(.grouped)
		.menuButton {
			Button("Modifier") {
				self.showSheet = true
			}
		}
    }
}

struct MotDetailView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			Text("")
				.navigationTitle("side")
		} detail: {
			MotDetailView(Mot(.preview))
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		.environmentObject(Settings.shared)

		
		NavigationSplitView(columnVisibility: .constant(.all)) {
			MotDetailView(Mot(.preview))
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		.environmentObject(Settings.shared)

    }
}
