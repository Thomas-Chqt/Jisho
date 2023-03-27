//
//  ContentViewModel.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
	
	@Published var currentPage: AppPage = .debug
	@Published var sideMenuIsShow = false
	
	func toggleSideMenu() {
		withAnimation {
			sideMenuIsShow.toggle()
		}
	}
	
	func switchPage(newPage: AppPage) {
		self.currentPage = newPage
		withAnimation {
			sideMenuIsShow = false
		}
	}
}
