//
//  DebugPageDetailMetaDataListRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/23.
//

import SwiftUI

struct DebugPageDetailMetaDataListRowView: View {
	
	@StateObject var metaData: MetaData
	
    var body: some View {
		VStack {
			TextField("text", text: metaDataTextBinding)
//			Text("\(metaData.text ?? "nil")")
		}
    }
	
	var metaDataTextBinding: Binding<String> {
		Binding {
			metaData.text ?? ""
		} set: {
			metaData.text = $0
			Task {
				try await DataController.shared.save()
			}
		}
	}
}

struct DebugPageDetailMetaDataListRowView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationSplitView {
			List(selection: .constant("")) {
				EmptyView()
			}
		} detail: {
			List {
				DebugPageDetailMetaDataListRowView(metaData: MetaData(.preview))
			}
			.listStyle(.plain)
			.navigationTitle("MetaData")
		}
    }
}
