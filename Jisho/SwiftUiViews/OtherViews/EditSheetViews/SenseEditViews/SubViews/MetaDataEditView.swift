//
//  MetaDataEditView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/07.
//

import SwiftUI

struct MetaDataEditView: View {
	
	@ObservedObject var metaData: MetaData
	
	var action: () -> Void
	
	init(metaData: MetaData, onTap: @escaping () -> Void) {
		self.metaData = metaData
		self.action = onTap
	}
	
    var body: some View {
		Text(metaData.text ?? "Aucune traduction pour les langues selectioné")
			.clickable(action: action)
    }
}

struct MetaDataEditView_Previews: PreviewProvider {
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
					MetaDataEditView(metaData: MetaData(.preview), onTap: { print("Bite") })
				}
			}
		}
	}
}
