//
//  SideMenu.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import Foundation
import SwiftUI

struct SideMenu: ViewModifier {
	
	@Binding var currentPage: AppPages
	@Binding var isPresented: Bool
	
	var sideMenuSelecction: Binding<AppPages?> {
		return Binding(get: { currentPage }, set: {
			currentPage = $0 ?? .search
			closeSideMenu()
		})

	}
	
	func body(content: Content) -> some View {
		ZStack(alignment: .leading) {
			content
				.offset(x: isPresented ? 200 : 0)
				.zIndex(1)
				.environment(\.toggleSideMenu, {
					withAnimation {
						isPresented.toggle()
					}
				})
			
			if isPresented {
				Rectangle().fill(Color.primary.opacity(0.2))
					.ignoresSafeArea()
					.onTapGesture(perform: closeSideMenu)
					.zIndex(2)
				SideMenuView(selection: sideMenuSelecction).frame(width: 200)
					.transition(.move(edge: .leading))
					.zIndex(3)
			}
		}
	}
		
	func closeSideMenu() {
		withAnimation {
			isPresented = false
		}
	}
}


extension View {
	func sideMenu(currentPage: Binding<AppPages>, isPresented: Binding<Bool>) -> some View {
		self.modifier(SideMenu(currentPage: currentPage, isPresented: isPresented))
	}
}


struct SideMenu_Previews: PreviewProvider {
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
