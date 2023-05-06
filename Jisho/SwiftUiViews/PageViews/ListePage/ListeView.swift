//
//  ListeView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/04.
//

import SwiftUI

struct ListeView: View {
	
	@ObservedObject var liste: Liste
	@Binding var selection: ListePageNavigationModel.S?
	
	@State private var editedListe: UUID? = nil
	
    var body: some View {
		Group {
			if liste.subListes.isEmpty && liste.mots.isEmpty {
				Color.clear.contentShape(Rectangle())
					.dropDestination(shouldEnableDrag: true, for: Liste.self, action: insertList)
			}
			else {
				List(selection: $selection) {
					ForEachWithDropDestination(liste.subListes, action: insertList) { liste in
						ListeRowView(liste: liste, editedListe: $editedListe)
					}
					.onDelete(perform: deleteListe)
					.onMove(perform: moveListe)
					
					ForEach(liste.mots) { mot in
						MotRowView(mot: mot)
					}
				}
				.listStyle(.plain)
			}
		}
		.navigationTitle(liste.name)
		.showSideMenuButton()
		.addButton(createListe)
    }
	
	
	func createListe() {
		let newListe = Liste(name: "")
		self.liste.subListes.append(newListe)
		self.editedListe = newListe.id
		
		DataController.shared.save()
	}
	
	func deleteListe(indexSet: IndexSet) {
		for index in indexSet {
			self.liste.subListes[index].delete()
		}
		
		DataController.shared.save()
	}
	
	func moveListe(from src: IndexSet, to dest: Int) {
		self.liste.subListes.move(fromOffsets: src, toOffset: dest)
		
		DataController.shared.save()
	}
	
	func insertList(listes: [Liste], index: Int? = nil) {
		self.liste.moveIn(listes, at: index)
		
		DataController.shared.save()
	}
	
	func insertList(listes: [Liste], pos: CGPoint) -> Bool {
		self.insertList(listes: listes)
		
		DataController.shared.save()
		return true
	}
	
	

}

struct ListeView_Previews: PreviewProvider {
    static var previews: some View {
		WrappedView()
			.environmentObject(Settings.shared)
    }
	
	struct WrappedView: View {
		
		@StateObject var navModel = ListePageNavigationModel()
		
		var body: some View {
			NavigationSplitView {
				NavigationStack {
					ListeView(liste: Liste(.preview), selection: $navModel.selection)
				}
			} detail: {
				navModel.selection?.view
			}

		}
	}
}


