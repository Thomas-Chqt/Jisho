//
//  ViewExtensions.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import Foundation
import SwiftUI

extension View {
	func sideMenu(isPresented: Binding<Bool>, size: SideMenuSize = .big, currentPage: Binding<AppPage>) -> some View {
		
		return ZStack(alignment: .leading) {
			self
				.offset(x: isPresented.wrappedValue ? size.rawValue : 0)
				.zIndex(1)
			
			if isPresented.wrappedValue {
				Rectangle()
					.fill(Color.primary.opacity(0.2))
					.ignoresSafeArea()
					.onTapGesture(perform: closeSideMenu)
					.zIndex(2)
				SideMenuView(size: size)
					.transition(.move(edge: .leading))
					.zIndex(3)
			}
		}
		
		
		func closeSideMenu() {
			withAnimation {
				isPresented.wrappedValue.toggle()
			}
		}
	}
	
	func menuButton<Content : View>(@ViewBuilder content: () -> Content) -> some View  {
		self
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Menu(content: content) {
						Image(systemName: "ellipsis.circle")
					}
				}
			}
	}
	
	func showSideMenuButton(showSideMenu: @escaping () -> Void) -> some View {
		self
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: showSideMenu) {
						Image(systemName: "list.bullet")

					}
				}
			}
	}
	
	func fileExporter<Delegate: FileExporterDelegate>(_ delegate: Delegate) -> some View {
		self.fileExporter(isPresented: delegate.isPresented,
						  document: delegate.document,
						  contentType: delegate.contentType,
						  defaultFilename: delegate.defaultFilename,
						  onCompletion: delegate.onCompletion)
	}
}
