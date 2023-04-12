//
//  SenseEditSheetView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/06.
//

import SwiftUI
import CoreData

struct SenseEditSheetView: View {
	
	@Environment(\.managedObjectContext) var viewContext
	@EnvironmentObject var settings: Settings
	
	@ObservedObject var sense: Sense
	
	@State var metaDataForSelector: Binding<MetaData?>? = nil
	
	init(_ sense: Sense) {
		self.sense = sense
	}
	
    var body: some View {
		List {
			Section(header: Text("MetaData"), footer: Button("Ajouter", action: addMetaData)){
				if let metaDatas = sense.metaDatas {
					ForEach(0..<metaDatas.count, id: \.self) { index in
						MetaDataEditView(metaData: sense.metaDatas![index]) {
							metaDataForSelector = sense.metaDataBinding(for: index)
						}
					}
					.onDelete(perform: removeMetaData)
					.onMove(perform: moveMetaData)
				}
			}
			Section(header: Text("Traductions"), footer: Button("Ajouter", action: addTraduction)){
				ForEach(sense.traductions?.fitToSettings(using: settings) ?? []) { traduction in
					TraductionEditSheetView(traduction: traduction,
											excludeLangue: sense.traductions?.map { $0.langue })
				}
				.onDelete(perform: deleteTraduction)
			}
		}
		.scrollDismissesKeyboard(.interactively)
		.navBarEditButton()
		.metaDataPicker(replacedMetaData: $metaDataForSelector, excludedMetaData: sense.metaDatas?.map { $0.id })
    }
	
	func addTraduction() {
		_ = sense.addTraduction(Traduction(.empty, context: viewContext))
	}
	
	func deleteTraduction(_ indexSet: IndexSet) {
		guard let traductions = sense.traductions?.fitToSettings(using: settings) else { return }
		for index in indexSet {
			traductions[index].delete()
		}
	}
	
	
	func addMetaData() {
		metaDataForSelector = Binding {
			return nil
		} set: {
			guard let newValue = $0 else { return }
			sense.metaDatas = (sense.metaDatas ?? []) + [newValue]
		}
	}
	
	func removeMetaData(_ indexSet: IndexSet) {
		guard let metaDatas = sense.metaDatas else { return }
		for index in indexSet {
			sense.removeMetaData(metaDatas[index])
		}
	}
	
	func moveMetaData(from sources: IndexSet, to destination: Int) {
		if sense.metaDatas == nil { return }
		sense.metaDatas!.move(fromOffsets: sources, toOffset: destination)
	}
}

struct SenseEditSheetView_Previews: PreviewProvider {
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
					SenseEditSheetView(Sense(.preview))
				}
				.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
				.environmentObject(Settings.shared)
			}
		}
	}
}
