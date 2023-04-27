//
//  MetaDataPickerRow.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/22.
//

import SwiftUI

struct MetaDataPickerRow: View {
	
	@FocusState var isFocus: Bool
	
	@ObservedObject var metaData: CommunMetaData
	@Binding var editState: UUID?
	var action: (() -> Void)?
	
    var body: some View {
		if editState == metaData.id {
			TextField("", text: $metaData.text.nonOptional)
				.focused($isFocus)
				.onSubmit { editState = nil }
				.onAppear { isFocus = true }
				.onChange(of: isFocus) {
					if $0 == false && editState == metaData.id { editState = nil }
				}
		}
		else {
			HStack {
				Text(metaData.text ?? "Aucune traduction pour les langues selectioné")
					.clickable(action: action)
				
				Button {
					editState = metaData.id
				} label: {
					Image(systemName: "pencil.circle")
				}
			}
		}
    }
}

struct MetaDataPickerRow_Previews: PreviewProvider {
    static var previews: some View {
		WrappedView()
			.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
    }
	
	struct WrappedView: View {
		
		@FetchRequest(sortDescriptors: []) var metaDatas: FetchedResults<CommunMetaData>
		@State var editState: UUID? = nil
		
		var body: some View {
			NavigationStack {
				List {
					ForEach([CommunMetaData(.empty)]) { metaData in
						MetaDataPickerRow(metaData: metaData, editState: $editState) {
							print("Action")
						}
					}
				}
				.menuButton {
					Button("add") {
						_ = CommunMetaData(.preview)
					}
				}
			}
		}
	}
}
