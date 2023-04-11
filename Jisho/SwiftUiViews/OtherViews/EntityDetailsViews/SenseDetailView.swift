//
//  SenseDetailView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/05.
//

import SwiftUI

struct SenseDetailView: View {
	
	@EnvironmentObject var settings: Settings
	
	@ObservedObject var sense: Sense
	@State var showSheet: Bool = false
	
	init(_ sense: Sense) {
		self.sense = sense
	}
	
    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			if let metaDatas = sense.metaDatas {
				ForEach(Array(metaDatas.enumerated()), id :\.element.id) { offset, metaData in
					if offset != 0 { Divider() }
					MetaDataDetailView(metaData)
				}
			}
			if sense.metaDatas?.count ?? 0 > 0 || sense.traductions?.count ?? 0 > 0 {
				Divider()
			}
			if let traductions = sense.traductions?.fitToSettings(using: settings) {
				ForEach(Array(traductions.enumerated()), id :\.element.id) { offset, traduction in
					if offset != 0 { Divider() }
					TraductionDetailView(traduction)
						.padding(9)
				}
			}
		}
		.contextMenu {
			Button {
				showSheet.toggle()
			}
			label: { Label("Modifier", systemImage: "pencil.circle") }
		}
		.listRowInsets(EdgeInsets())
		.sheet(isPresented: $showSheet) {
			NavigationStack {
				SenseEditSheetView(sense)
			}
		}
    }
}

struct SenseDetailView_Previews: PreviewProvider {
	
    static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			Text("")
				.navigationTitle("side")
		} detail: {
			List {
				SenseDetailView(Sense(.preview))
			}
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		.environmentObject(Settings.shared)

		
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List {
				SenseDetailView(Sense(.preview))
			}
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		.environmentObject(Settings.shared)
    }
}
