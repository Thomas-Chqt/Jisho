//
//  JaponaisDetailsView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/04.
//

import SwiftUI

struct JaponaisDetailsView: View {
	
	@ObservedObject var japonais: Japonais
	
	@State var showSheet: Bool = false
	
	init(_ japonais: Japonais) {
		self.japonais = japonais
	}
	
    var body: some View {
		VStack(alignment: .leading) {
			if japonais.kanas.count > 0 {
				ScrollView(.horizontal) {
					HStack {
						ForEach(Array(japonais.kanas.enumerated()), id: \.element) { index, kana in
							if index != 0 { Divider().frame(height: 15) }
							Text(kana).font(japonais.kanjis.isEmpty ? .largeTitle : .footnote)
						}
					}
				}
				.scrollIndicators(.hidden)
			}
			
			if japonais.kanjis.count > 0 {
				ScrollView(.horizontal) {
					HStack {
						ForEach(Array(japonais.kanjis.enumerated()), id: \.element) { index, kanji in
							if index != 0 { Divider().frame(height: 30) }
							Text(kanji).font(japonais.kanas.isEmpty ? .largeTitle : .title)
						}
					}
				}
				.scrollIndicators(.hidden)
			}
		}
		.frame(height: 50)
		.contextMenu {
			Button(action: { showSheet.toggle() },
				   label: { Label("Modifier", systemImage: "pencil.circle") })
		}
		.sheet(isPresented: $showSheet, onDismiss: DataController.shared.save) {
			JaponaisEditView(japonais: japonais)
		}
	}
}




struct JaponaisDetailsView_Previews: PreviewProvider {
	
	
	static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			Text("")
				.navigationTitle("side")
		} detail: {
			List {
				JaponaisDetailsView(Japonais(.preview))
				JaponaisDetailsView(Japonais(kanjis: ["猫"]))
				JaponaisDetailsView(Japonais(kanas: ["ねこ"]))

			}
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		
		
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List {
				JaponaisDetailsView(Japonais(.preview))
				JaponaisDetailsView(Japonais(kanjis: ["猫"]))
				JaponaisDetailsView(Japonais(kanas: ["ねこ"]))
			}
			.listStyle(.grouped)
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
	}
}

