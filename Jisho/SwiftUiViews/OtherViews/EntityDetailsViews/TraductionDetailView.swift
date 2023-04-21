//
//  TraductionDetailView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/06.
//

import SwiftUI

struct TraductionDetailView: View {
	
	@ObservedObject var traduction: Traduction
	@State var showSheet: Bool = false
	
	init(_ traduction: Traduction) {
		self.traduction = traduction
	}
	
    var body: some View {
		HStack(alignment: .top) {
			Text(traduction.langue.flag)
			Text(traduction.text)
		}
		.contextMenu {
			Button(action: { showSheet.toggle() },
				   label: { Label("Modifier", systemImage: "pencil.circle") })
		}
    }
}

struct TraductionDetailView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationSplitView(columnVisibility: .constant(.all)) {
			Text("")
				.navigationTitle("side")
		} detail: {
			List {
				TraductionDetailView(Traduction(.preview))
			}
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		
		
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List {
				TraductionDetailView(Traduction(.preview))
			}
		} detail: {
			EmptyView()
		}
		.navigationSplitViewStyle(.balanced)
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
	}
}
