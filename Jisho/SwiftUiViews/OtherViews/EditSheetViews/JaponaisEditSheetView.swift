//
//  JaponaisEditSheetView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/10.
//

import SwiftUI

struct JaponaisEditSheetView: View {
	
	@Environment(\.managedObjectContext) var context
	
	@ObservedObject var japonais: Japonais
	
	init(_ japonais: Japonais) {
		self.japonais = japonais
	}
	
    var body: some View {
		List {
			Section(header: Text("Kanas"), footer: Button("Ajouter", action: addKana)) {
				if let kanas = japonais.kanas {
					ForEach(0..<kanas.count, id: \.self) { index in
						TextField("Kana", text: japonais.kanaBinding(for: index)!)
					}
					.onDelete(perform: deleteKana)
					.onMove(perform: moveKana)
				}
			}
			
			Section(header: Text("Kanjis"), footer: Button("Ajouter", action: addKanji)) {
				if let kanjis = japonais.kanjis {
					ForEach(0..<kanjis.count, id: \.self) { index in
						TextField("kanij", text: japonais.kanjiBinding(for: index)!)
					}
					.onDelete(perform: deleteKanji)
					.onMove(perform: moveKanji)
				}
			}
		}
		.navBarEditButton()
    }
	
	
	func addKanji() {
		japonais.kanjis = (japonais.kanjis ?? []) + [""]
	}
	
	func deleteKanji(indexSet: IndexSet) {
		for index in indexSet {
			japonais.kanjis?.remove(at: index)
		}
	}
	
	func moveKanji(from src: IndexSet, to dest: Int) {
		japonais.kanjis?.move(fromOffsets: src, toOffset: dest)
	}
	
	
	func addKana() {
		japonais.kanas = (japonais.kanas ?? []) + [""]
	}
	
	func deleteKana(indexSet: IndexSet) {
		for index in indexSet {
			japonais.kanas?.remove(at: index)
		}
	}
	
	func moveKana(from src: IndexSet, to dest: Int) {
		japonais.kanas?.move(fromOffsets: src, toOffset: dest)
	}
}





struct JaponaisEditSheetView_Previews: PreviewProvider {
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
					JaponaisEditSheetView(Japonais(.preview))
				}
				.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
				.environmentObject(Settings.shared)
			}
		}
	}
}
