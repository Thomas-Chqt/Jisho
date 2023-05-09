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
					.dropDestination(shouldReEnableDrag: true, for: Liste.DropableItem.self, action: insertAny)
			}
			else {
				List(selection: $selection) {
					ForEachWithDropDestination(liste.subListes, action: insertList) { liste in
						ListeRowView(liste: liste, editedListe: $editedListe)
					}
					.onDelete(perform: deleteListe)
					.onMove(perform: moveListe)
					
					ForEachWithDropDestination(liste.mots, action: insertMots) { mot in
						MotRowView(mot: mot)
							.onDrag(allowMulitpleSelection: false) {
								NSItemProvider(object: Mot.WithSrcListe(mot: mot, srcListe: self.liste))
							}
					}
					.onDelete(perform: removeMot)
					.onMove(perform: moveListe)
				}
				.listStyle(.plain)
			}
		}
		.navigationTitle(liste.name)
		.showSideMenuButton()
		.addButton(createListe)
    }
	
	
	//MARK: Listes
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
	
	
	func insertList(anys: [Liste.DropableItem], index: Int) {
		
		var index = index
		
		for any in anys {
			if let liste = any.liste {
				self.liste.moveIn(liste, at: index)
				index += 1
			}
			else if let motWithSrcListe = any.motWithSrcListe {
				self.liste.moveIn(motWithSrcListe.mot, from: motWithSrcListe.srcListe)
			}
		}

		DataController.shared.save()
	}

	
	
	//MARK: Mots
	func removeMot(indexSet: IndexSet) {
		for index in indexSet {
			self.liste.mots.remove(at: index)
		}
		
		DataController.shared.save()
	}
	
	func moveMot(from src: IndexSet, to dest: Int) {
		self.liste.mots.move(fromOffsets: src, toOffset: dest)
		
		DataController.shared.save()
	}
	
	
	func insertMots(anys: [Liste.DropableItem], index: Int) {
		
		var index = index
		
		for any in anys {
			if let liste = any.liste {
				self.liste.moveIn(liste)
				
			}
			else if let motWithSrcListe = any.motWithSrcListe {
				self.liste.moveIn(motWithSrcListe.mot, from: motWithSrcListe.srcListe, at: index)
				index += 1
			}
		}
		
		DataController.shared.save()
	}
		
	
	//MARK: Anys
	func insertAny(anys: [Liste.DropableItem], pos: CGPoint) -> Bool {
		for any in anys {
			if let liste = any.liste {
				self.liste.moveIn(liste)
			}
			else if let motWithSrcListe = any.motWithSrcListe {
				self.liste.moveIn(motWithSrcListe.mot, from: motWithSrcListe.srcListe)
			}
		}
		
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


