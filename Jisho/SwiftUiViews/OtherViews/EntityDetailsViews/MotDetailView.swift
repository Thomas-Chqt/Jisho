//
//  MotDetailView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/04.
//

import SwiftUI

struct MotDetailView: View {
	
	@ObservedObject var mot: Mot
	
	init(_ mot: Mot) {
		self.mot = mot
	}
	
    var body: some View {
		List {
			Section("Japonais") {
				ForEach(mot.japonais ?? []) { jap in
					JaponaisDetailsView(jap)
				}
				.onMove(perform: moveJap)
			}
			if let senses = mot.senses {
				ForEach(0..<senses.count, id: \.self) { index in
					Section("Sense \(index + 1)") {
						SenseDetailView(senses[index])
					}
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.listStyle(.grouped)
		.menuButton {
			Text("Test")
		}
    }
	
	func moveJap(from source: IndexSet, to destination: Int) {
		mot.japonais?.move(fromOffsets: source, toOffset: destination)
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
