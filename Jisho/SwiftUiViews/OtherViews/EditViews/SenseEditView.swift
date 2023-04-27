//
//  SenseEditView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/22.
//

import SwiftUI

struct SenseEditView: View {
	@Environment(\.managedObjectContext) var viewContext
	@EnvironmentObject var settings: Settings

	@State var metaDataForPicker: Binding<CommunMetaData?>? = nil

	@ObservedObject var sense: Sense
	
    var body: some View {
		List {
			Section(header: Text("MetaData Commune"), footer: Button("Ajouter", action: addCommunMetaData)){
				ForEach($sense.communMetaDatas) { metaData in
					CommunMetaDataEditView(metaData: metaData.wrappedValue) {
						metaDataForPicker = metaData.optionalValue
					}
				}
				.onDelete(perform: removeCommunMetaData)
				.onMove(perform: moveCommunMetaData)
			}
			
			Section(header: Text("MetaData Unique"), footer: Button("Ajouter", action: addUniqueMetaData)){
				ForEach($sense.uniqueMetaDatas) { metaData in
					TextField("MetaData", text: metaData.text.nonOptional)
				}
				.onDelete(perform: deleteUniqueMetaData)
				.onMove(perform: moveUniqueMetaData)
			}
			
			Section(header: Text("Traductions"), footer: Button("Ajouter", action: addTraduction)){
				ForEach(sense.traductions.fitToSettings(using: settings)) { traduction in
					TraductionEditView(traduction: traduction,
									   existingLanguesInSense: Set(sense.traductions.map{$0.langue}))
				}
				.onDelete(perform: deleteTraduction)
			}
		}
		.scrollDismissesKeyboard(.interactively)
		.navBarEditButton()
		.metaDataPicker(selectedMetaData: $metaDataForPicker, inSense: sense)
		
    }
	
	
	func addTraduction() {
		_ = sense.addTraduction(Traduction(.empty, context: viewContext))
	}
	
	func deleteTraduction(_ indexSet: IndexSet) {
		for index in indexSet {
			sense.traductions.fitToSettings(using: settings)[index].delete()
		}
	}
	
	
	func addCommunMetaData() {
		metaDataForPicker = Binding {
			return nil
		} set: {
			guard let newValue = $0 else { return }
			sense.communMetaDatas.append(newValue)
		}
	}
	
	func removeCommunMetaData(_ indexSet: IndexSet) {
		for index in indexSet {
			sense.removeCommunMetaData(sense.communMetaDatas[index])
		}
	}
	
	func moveCommunMetaData(from sources: IndexSet, to destination: Int) {
		sense.communMetaDatas.move(fromOffsets: sources, toOffset: destination)
	}
	
	
	func addUniqueMetaData() {
		sense.uniqueMetaDatas.append(UniqueMetaData(.empty, context: viewContext))
	}
	
	func deleteUniqueMetaData(_ indexSet: IndexSet) {
		for index in indexSet {
			sense.uniqueMetaDatas[index].delete()
		}
	}
	
	func moveUniqueMetaData(from sources: IndexSet, to destination: Int) {
		sense.uniqueMetaDatas.move(fromOffsets: sources, toOffset: destination)
	}
}

struct SenseEditView_Previews: PreviewProvider {
    static var previews: some View {
        WrappedView()
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
			.environmentObject(Settings.shared)
    }
	
	struct WrappedView: View {
		
		@State var showSheet = true
		
		var body: some View {
			Button("Show sheet") { showSheet.toggle() }
				.sheet(isPresented: $showSheet) {
					NavigationStack {
						SenseEditView(sense: Sense(.preview))
					}
				}
		}
	}
}


