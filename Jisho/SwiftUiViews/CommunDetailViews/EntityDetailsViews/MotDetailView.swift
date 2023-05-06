//
//  MotDetailView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/04.
//

import SwiftUI

struct MotDetailView: View {
	
	@FetchRequest(fetchRequest: Liste.allListesFetchRequest()) var allListes: FetchedResults<Liste>
	
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
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				starButton
			}
		}
		.sheet(isPresented: $showSheet, onDismiss: DataController.shared.save) {
			MotEditView(mot: mot)
		}
    }
	
	@ViewBuilder
	var starButton: some View {
		if allListes.count <= 1 {
			if let onlyListe = allListes.first {
				Button {
					onlyListe.toggleMot(self.mot)
					DataController.shared.save()
				} label: {
					if onlyListe.contains(self.mot) {
						Image(systemName: "star.fill")
					}
					else {
						Image(systemName: "star")
					}
				}

			} else { EmptyView() }
		}
		else {
			Menu {
				ForEach(self.allListes) { liste in
					Button {
						liste.toggleMot(self.mot)
						DataController.shared.save()
					} label: {
						HStack {
							if liste.contains(self.mot) {
								Image(systemName: "star.fill")
							}
							else {
								Image(systemName: "star")
							}
							
							Text(liste.name)
						}
					}
				}
			} label: {
				if self.mot.listesIn.isEmpty {
					Image(systemName: "star")
				}
				else {
					Image(systemName: "star.fill")
				}
			}

		}
		
	}
}

struct MotDetailView_Previews: PreviewProvider {
	static var previews: some View {
		WrappedView()
			.environmentObject(Settings.shared)
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
	}
	
	struct WrappedView: View {
		
		@State var selection: Mot? = nil
		
		var mots = [ Mot(.preview), Mot(.preview) ]
		
		var body: some View {
			NavigationSplitView {
				List(selection: $selection) {
					ForEach([ Mot(.preview), Mot(.preview) ]) { mot in
						MotRowView(mot: mot)
					}
				}
				.listStyle(.plain)
				.navigationTitle("Preview")
				.onAppear {
					selection = Mot(.preview)
				}
			} detail: {
				selection?.view
			}
			
		}
	}
	
}
