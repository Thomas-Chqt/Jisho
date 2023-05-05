//
//  RootListePageView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct RootListePageView: View {
	@StateObject var navModel = ListePageNavigationModel()

	@FetchRequest(fetchRequest: Liste.rootListesFetchRequest()) var fetchResult: FetchedResults<Liste>
	
	@State private var editedListe: UUID? = nil
		
	var rootLists: [Liste] {
		get {
			return fetchResult.map { $0 }
		}
		nonmutating set {
			for (i, liste) in newValue.enumerated() {
				liste.order = i
			}
		}
	}
	
    var body: some View {
		NavigationSplitView {
			NavigationStack {
				List {
					ForEachWithDropDestination(rootLists, action: insertList) { liste in
						ListeRowView(liste: liste, editedListe: $editedListe)
					}
					.onDelete(perform: deleteListe)
					.onMove(perform: moveListe)
				}
				.listStyle(.plain)
				.navigationDestination(for: Liste.self) { liste in
					ListeView(liste: liste, selection: $navModel.selection)
				}
			}
			.navigationTitle(AppPages.listes.fullName)
			.showSideMenuButton()
			.addButton(createListe)
		} detail: {
			
		}
    }
	
	
	func createListe() {
		let newListe = Liste(.empty)
		self.rootLists.append(newListe)
		self.editedListe = newListe.id
		
		DataController.shared.save()
	}
	
	func deleteListe(indexSet: IndexSet) {
		for index in indexSet {
			rootLists[index].delete()
		}
		
		DataController.shared.save()
	}
	
	func moveListe(from src: IndexSet, to dest: Int) {
		self.rootLists.move(fromOffsets: src, toOffset: dest)
		
		DataController.shared.save()
	}
	
	func insertList(listes: [Liste], index: Int? = nil) {
		self.rootLists.moveIn(listes, at: index)
		
		DataController.shared.save()
	}
}

struct RootListePageView_Previews: PreviewProvider {
    static var previews: some View {
        WrappedView()
    }
	
	struct WrappedView: View {
		
		@State var isDragEnable = true
		@StateObject var myDispatchQueue = MyDispatchQueue()
		
		var body: some View {
			RootListePageView()
				.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
				.environment(\.isDragEnable, $isDragEnable)
				.environmentObject(myDispatchQueue)
		}
	}
}



