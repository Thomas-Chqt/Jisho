//
//  MotEditSheetView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/11.
//

import SwiftUI

struct MotEditSheetView: View {
	
	@ObservedObject var mot: Mot
	
	init(_ mot: Mot) {
		self.mot = mot
	}
	
    var body: some View {
		NavigationStack {
			List {
				Section(header: Text("Japonais"), footer: Button("Ajouter", action: addJaponais)) {
					ForEach(mot.japonais ?? []) { japonais in
						NavigationLink("\(japonais.primary ?? "") - \(japonais.secondary ?? "")") {
							JaponaisEditSheetView(japonais)
						}
					}
					.onMove(perform: moveJaponais)
					.onDelete(perform: deleteJaponais)
				}
				
				Section(header: Text("Senses"), footer: Button("Ajouter", action: addSense)) {
					ForEach(mot.senses ?? []) { sense in
						NavigationLink(sense.primary ?? "") {
							SenseEditSheetView(sense)
						}
					}
					.onMove(perform: moveSense)
					.onDelete(perform: deleteSense)
				}
			}
			.navBarEditButton()
			.onAppear { mot.objectWillChange.send() }
		}
    }
	
	
	func addJaponais() {
		mot.japonais = (mot.japonais ?? []) + [Japonais(.empty)]
	}
	
	func deleteJaponais(at indexSet: IndexSet) {
		for index in indexSet {
			mot.japonais?[index].delete()
		}
	}
	
	func moveJaponais(from src: IndexSet, to dest: Int) {
		mot.japonais?.move(fromOffsets: src, toOffset: dest)
	}
	
	
	func addSense() {
		mot.senses = (mot.senses ?? []) + [Sense(.empty)]
	}
	
	func deleteSense(at indexSet: IndexSet) {
		for index in indexSet {
			mot.senses?[index].delete()
		}
	}
	
	func moveSense(from src: IndexSet, to dest: Int) {
		mot.senses?.move(fromOffsets: src, toOffset: dest)
	}
}

struct MotEditSheetView_Previews: PreviewProvider {
	static var previews: some View {
		wrappedView()
	}
	
	struct wrappedView: View {
		
		@State var showSheet: Bool = true
		
		var body: some View {
			Button("Show Sheet") {
				showSheet.toggle()
			}
			.sheet(isPresented: $showSheet, onDismiss: { print("Dismiss") }) {
				NavigationStack {
					MotEditSheetView(Mot(.preview))
				}
				.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
				.environmentObject(Settings.shared)
			}
		}
	}
}
