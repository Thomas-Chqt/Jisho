//
//  CommunMetaDataEditView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/22.
//

import SwiftUI

struct CommunMetaDataEditView: View {
	
	@ObservedObject var metaData: CommunMetaData
	var action: (() -> Void)?
	
    var body: some View {
		Text(metaData.text ?? "Aucune traduction pour les langues selectioné")
			.clickable(action: action)
    }
}

struct CommunMetaDataEditView_Previews: PreviewProvider {
	static var previews: some View {
		wrappedView()
	}
	
	struct wrappedView: View {
		
		@State var showSheet: Bool = true
		
		var body: some View {
			Button("Show Sheet") {
				showSheet.toggle()
			}
			.sheet(isPresented: $showSheet) {
				List {
					Section {
						CommunMetaDataEditView(metaData: CommunMetaData(.preview)) {
							print("Action")
						}
					}
					Section {
						CommunMetaDataEditView(metaData: CommunMetaData(.empty)) {
							print("Action")
						}
					}
					Section {
						CommunMetaDataEditView(metaData: CommunMetaData(.preview))
					}
					Section {
						CommunMetaDataEditView(metaData: CommunMetaData(.empty))
					}
				}
			}
		}
	}
}
