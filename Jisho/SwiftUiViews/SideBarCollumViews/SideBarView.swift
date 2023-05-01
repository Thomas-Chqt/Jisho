//
//  SideBarView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/28.
//

import SwiftUI

struct SideBarView: View {
	
	@Binding var selection: ContentCollumRoot?
	
    var body: some View {
		List(ContentCollumRoot.sideMenuList, selection: $selection) { page in
			NavigationLink(value: page) {
				HStack {
					page.icone
					Text("\(page.fullName)")
				}
			}
		}
		.listStyle(.sidebar)
		.navigationTitle("Menu")
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
		wrappedView()
    }
	
	struct wrappedView: View {
		
		@State var contentCollumRoot: ContentCollumRoot? = nil
		
		var body: some View {
			NavigationSplitView(columnVisibility: .constant(.all)) {
				SideBarView(selection: $contentCollumRoot)
			} content: {
				Text("\(contentCollumRoot?.fullName ?? "No selection")")
			} detail: {
				EmptyView()
			}
			
		}
		
	}
}
