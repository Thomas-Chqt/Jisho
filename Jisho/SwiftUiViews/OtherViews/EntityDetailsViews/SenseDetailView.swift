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
			ForEach(Array(sense.metaDatas.enumerated()), id :\.element.id) { offset, metaData in
				if offset != 0 { Divider() }
				MetaDataDetailView(metaData)
			}

			ForEach(Array(sense.traductions.fitToSettings(using: settings).enumerated()), id :\.element.id) { offset, traduction in
				if offset != 0 || sense.metaDatas.count > 0 { Divider() }
				TraductionDetailView(traduction)
					.padding(9)
			}
		}
		.listRowInsets(EdgeInsets())
		.contextMenu {
			Button(action: { showSheet.toggle() },
				   label: { Label("Modifier", systemImage: "pencil.circle") })
		}
    }
}

struct SenseDetailView_Previews: PreviewProvider {
	
	static var sense = Sense(.preview)
	
    static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			Text("")
				.navigationTitle("side")
		} detail: {
			List {
				SenseDetailView(sense)
			}
			.menuButton {
				Button("add commun metaData") {
					sense.metaDatas.append(CommunMetaData(.preview))
				}
				Button("add unique metaData") {
					sense.metaDatas.append(UniqueMetaData(.preview))
				}
				Button("add link metaData") {
					sense.metaDatas.append(LinkMetaData(.preview))
				}
			}

		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		.environmentObject(Settings.shared)

		
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List {
				SenseDetailView(sense)
			}
			.listStyle(.grouped)
			.menuButton {
				Button("add commun metaData") {
					sense.metaDatas.append(CommunMetaData(.preview))
				}
				Button("add unique metaData") {
					sense.metaDatas.append(UniqueMetaData(.preview))
				}
				Button("add link metaData") {
					sense.metaDatas.append(LinkMetaData(.preview))
				}
			}
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		.environmentObject(Settings.shared)
    }
}
