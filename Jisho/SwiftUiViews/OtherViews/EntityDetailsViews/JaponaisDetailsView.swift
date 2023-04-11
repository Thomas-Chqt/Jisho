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
			if (japonais.kanas?.count ?? 0) == 0 && (japonais.kanjis?.count ?? 0) == 0 {
				Text("")
					.font(.title)
			}
			if let kanas = japonais.kanas {
				ScrollView(.horizontal) {
					HStack {
						ForEach(0..<kanas.count, id: \.self) { index in
							if index != 0 {
								Divider().frame(height: 15)
							}
							Text(japonais.kanas?[index] ?? "")
						}
					}
				}
				.scrollIndicators(.hidden)
			}
			if let kanjis = japonais.kanjis {
				ScrollView(.horizontal) {
					HStack {
						ForEach(0..<kanjis.count, id: \.self) { index in
							if index != 0 {
								Divider().frame(height: 30)
							}
							Text(japonais.kanjis?[index] ?? "")
								.font(.title)
						}
					}
				}
				.scrollIndicators(.hidden)
			}
		}
		.contextMenu {
			Button(action: { showSheet.toggle() },
				   label: { Label("Modifier", systemImage: "pencil.circle") })
		}
		.editSheet(isPresented: $showSheet, entityToEdit: japonais)
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
			}
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		
		
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List {
				JaponaisDetailsView(Japonais(.preview))
			}
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
	}
}
