//
//  JaponaisEditView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/23.
//

import SwiftUI

struct JaponaisEditView: View {
	@Environment(\.managedObjectContext) var context
	
	@ObservedObject var japonais: Japonais
	
	var body: some View {
		List {
			Section(header: Text("Kanas"), footer: Button("Ajouter", action: addKana)) {
				ForEach($japonais.kanas, id: \.self) { kanas in
					TextField("Kana", text: kanas)
				}
				.onDelete(perform: deleteKana)
				.onMove(perform: moveKana)
			}
			
			Section(header: Text("Kanjis"), footer: Button("Ajouter", action: addKanji)) {
				ForEach($japonais.kanjis, id: \.self) { kanji in
					TextField("Kanji", text: kanji)
				}
				.onDelete(perform: deleteKanji)
				.onMove(perform: moveKanji)
			}
		}
		.scrollDismissesKeyboard(.interactively)
		.navBarEditButton()
		
	}
	
	
	func addKanji() { japonais.kanjis.append("") }
	
	func deleteKanji(indexSet: IndexSet) {
		for index in indexSet {
			japonais.kanjis.remove(at: index)
		}
	}
	
	func moveKanji(from src: IndexSet, to dest: Int) {
		japonais.kanjis.move(fromOffsets: src, toOffset: dest)
	}
	
	
	func addKana() { japonais.kanas.append("") }
	
	func deleteKana(indexSet: IndexSet) {
		for index in indexSet {
			japonais.kanas.remove(at: index)
		}
	}
	
	func moveKana(from src: IndexSet, to dest: Int) {
		japonais.kanas.move(fromOffsets: src, toOffset: dest)
	}
}

struct JaponaisEditView_Previews: PreviewProvider {
	static var previews: some View {
		wrappedView()
	}
	
	struct wrappedView: View {
		
		@State var showSheet: Bool = true
		
		var body: some View {
			Button("Show Sheet") {
				showSheet.toggle()
			}
			.sheet(isPresented: $showSheet, onDismiss: {print("Dismiss")}) {
				NavigationStack {
					JaponaisEditView(japonais: Japonais(.preview))
				}
				.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
				.environmentObject(Settings.shared)
			}
		}
	}
}
