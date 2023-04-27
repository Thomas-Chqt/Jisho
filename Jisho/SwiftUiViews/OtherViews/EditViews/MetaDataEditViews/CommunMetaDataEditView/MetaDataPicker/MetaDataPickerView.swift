//
//  MetaDataPickerView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/22.
//

import SwiftUI

struct MetaDataPickerView: View {
	
	@Environment(\.managedObjectContext) var context
	@Environment(\.dismiss) var dismiss
	
	@FetchRequest(sortDescriptors: []) var metaDatas: FetchedResults<CommunMetaData>
	@State var editState: UUID? = nil
	
	@State var searchedText: String = ""

	@FocusState var isFocus:Bool

	@Binding var selectedMetaData: CommunMetaData?
	
	
	init(selectedMetaData: Binding<CommunMetaData?>, excludedIDs: [UUID]? = nil) {
		self._selectedMetaData = selectedMetaData
		
		let sortDescriptor = NSSortDescriptor(key: "createTime_atb", ascending: false)
		let predicate = NSPredicate(format: "NOT (id_atb IN %@)", (excludedIDs ?? []) as CVarArg)
		
		self._metaDatas = FetchRequest<CommunMetaData>(sortDescriptors: [sortDescriptor], predicate: predicate, animation: .default)
	}
	
    var body: some View {
		NavigationStack {
			List {
				if selectedMetaData != nil {
					Section("Selection") {
						TextField("MetaData", text: Binding(get: { selectedMetaData?.text ?? "" },
															set: { selectedMetaData?.text = $0}))
							.focused($isFocus)
							.onAppear { isFocus = true }
							.onSubmit { dismiss() }
					}
				}
				ForEach(metaDatas.filtered(by: searchedText)) { metaData in
					MetaDataPickerRow(metaData: metaData, editState: $editState) {
						selectedMetaData = metaData
						dismiss()
					}
				}
				.onDelete(perform: deleteMetaData)
			}
			.searchable(text: $searchedText, placement: .navigationBarDrawer)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: { addMetaData() },
						   label: { Image(systemName: "plus") })
					.padding()
				}
			}
		}
    }
	
	
	func addMetaData() {
		let newMetaData = CommunMetaData(.empty, context: context)
		self.editState = newMetaData.id
	}
	
	func deleteMetaData(indexSet: IndexSet) {
		for index in indexSet {
			metaDatas.filtered(by: searchedText)[index].delete()
		}
	}
}





struct MetaDataPickerView_Previews: PreviewProvider {
	static var previews: some View {
		wrappedView()
	}
	
	struct wrappedView: View {
		
		@State var metaDataForPicker: Binding<CommunMetaData?>? = nil
		@State var metaDatas = [ CommunMetaData(.preview), CommunMetaData(.preview) ]
		
		var body: some View {
			List {
				ForEach($metaDatas) { metaData in
					CommunMetaDataEditView(metaData: metaData.wrappedValue) {
						metaDataForPicker = metaData.optionalValue
					}
				}
			}
			.metaDataPicker(selectedMetaData: $metaDataForPicker, excludedIDs: metaDatas.map{ $0.id })
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		}
	}
}
