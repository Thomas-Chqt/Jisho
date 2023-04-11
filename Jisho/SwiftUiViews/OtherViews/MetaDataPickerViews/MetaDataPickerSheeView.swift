//
//  MetaDataPickerSheeView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/07.
//

import SwiftUI

struct MetaDataPickerSheeView: View {
	
	@Environment(\.managedObjectContext) var context
	@Environment(\.dismiss) var dismiss
	
	@FetchRequest var metaDatas: FetchedResults<MetaData>
	
	@State var searchedText: String = ""
	
	@FocusState var isFocus:Bool
	@State var editedMetaData: UUID? = nil
	
	@Binding var replacedMetaData: MetaData?
	var excludedMetaData: [UUID]?
	
	init(replacedMetaData: Binding<MetaData?>, excludedMetaData: [UUID]? = nil) {
		self._replacedMetaData = replacedMetaData
		self.excludedMetaData = excludedMetaData
		
		let sortDescriptor = NSSortDescriptor(key: "createTime_atb", ascending: false)
		let predicate = NSPredicate(format: "NOT (id_atb IN %@)", (excludedMetaData ?? []) as CVarArg)
		
		self._metaDatas = FetchRequest<MetaData>(sortDescriptors: [sortDescriptor],
												 predicate: predicate, animation: .default)
	}
		
    var body: some View {
		NavigationStack {
			List {
				if let replacedMetaData = replacedMetaData {
					Section("Selection") {
						TextField("MetaData", text: replacedMetaData.bindingText)
							.focused($isFocus)
							.onAppear { isFocus = true }
					}
				}
				ForEach(metaDatas.filtered(by: searchedText)) { metaData in
					Text(metaData.text ?? "Aucune traduction pour les langues selectioné")
						.clickable {
							self.replacedMetaData = metaData
							dismiss()
						}
						.editable(text: metaData.bindingText, editState: $editedMetaData, equals: metaData.id)
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
		let newMetaData = MetaData(id: UUID(), context: context)
		self.editedMetaData = newMetaData.id
	}
	
	func deleteMetaData(indexSet: IndexSet) {
		for index in indexSet {
			metaDatas.filtered(by: searchedText)[index].delete()
		}
	}
}











struct MetaDataPickerSheeView_Previews: PreviewProvider {
	static var previews: some View {
		wrappedView()
	}
	
	struct wrappedView: View {
		
		@State var metaDataForPicker: Binding<MetaData?>? = nil
		@State var metaDatas = [ MetaData(.preview), MetaData(.preview) ]
		
		var body: some View {
			List {
				ForEach(0..<metaDatas.count, id: \.self) { index in
					Text("\(metaDatas[index].traductions?.first?.text ?? "")")
						.clickable {
							metaDataForPicker = Binding(get: {
								metaDatas[index]
							}, set: {
								guard let newValue = $0 else { return }
								metaDatas[index] = newValue
							})
						}
				}
			}
			.onAppear {
				metaDataForPicker = Binding(get: {
					metaDatas[0]
				}, set: {
					guard let newValue = $0 else { return }
					metaDatas[0] = newValue
				})
			}
			.metaDataPicker(replacedMetaData: $metaDataForPicker, excludedMetaData: metaDatas.map { $0.id })
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		}
	}
}

