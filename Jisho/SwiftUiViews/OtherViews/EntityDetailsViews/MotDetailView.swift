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
	@State var sheetIsShow: Bool = false
	
	init(_ mot: Mot) {
		self.mot = mot
	}
	
    var body: some View {
		List {
			Section("Japonais") {
				ForEach(mot.japonais ?? []) { jap in
					JaponaisDetailsView(jap)
				}
			}
			if let senses = mot.senses {
				ForEach(0..<senses.count, id: \.self) { index in
					Section("Sense \(index + 1)") {
						SenseDetailView(senses[index])
					}
				}
			}
			TextField("Notes", text: mot.bindingNotes, axis: .vertical)
				.focused($notesIsFocused)
				.lineLimit(3...)
				.onSubmit {
					mot.notes = (mot.notes ?? "") + "\n"
					notesIsFocused = true
				}
		}
		.scrollDismissesKeyboard(.interactively)
		.navigationBarTitleDisplayMode(.inline)
		.listStyle(.grouped)
		.menuButton {
			Button("Modifier") {
				self.sheetIsShow = true
			}
		}
		.editSheet(isPresented: $sheetIsShow, entityToEdit: mot)
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
