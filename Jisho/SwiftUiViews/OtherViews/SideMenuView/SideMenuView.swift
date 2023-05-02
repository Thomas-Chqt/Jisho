//
//  SideMenuView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import SwiftUI

struct SideMenuView: View {
	
	@Binding var selection: AppPages?
	
    var body: some View {
		NavigationStack {
			List(selection: $selection) {
				SideMenuRowView(value: .search)
				SideMenuRowView(value: .listes)
				SideMenuRowView(value: .settings)
				SideMenuRowView(value: .debug)
			}
			.listStyle(.sidebar)
			.navigationTitle("Menu")
		}
    }
}

struct SideMenuView_Previews: PreviewProvider {
	static var previews: some View {
		WrappedView()
	}
	
	struct WrappedView: View {
		
		@State var isPresented = true
		@State var currentPage: AppPages = .search
		
		var body: some View {
			ZStack {
				Rectangle().fill(Color.blue.opacity(0.2))
					.onTapGesture {
						withAnimation {
							isPresented = true
						}
					}
				Text(currentPage.fullName)
			}
			.modifier(SideMenu(currentPage: $currentPage, isPresented: $isPresented))
		}
	}

}
