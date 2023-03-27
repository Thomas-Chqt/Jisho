//
//  SideMenuButtonView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/20.
//

import SwiftUI

struct SideMenuButtonView: View {
	
	@Environment(\.switchPage) var swichPage
	
	var size: SideMenuSize
	var icone:Image
	var text:String
	var action: (() -> Void)?
	var page: AppPage?
	
	init(size: SideMenuSize, icone: Image, text: String, action: @escaping () -> Void) {
		self.size = size
		self.icone = icone
		self.text = text
		self.action = action
	}
	
	init(size: SideMenuSize, page: AppPage) {
		self.size = size
		self.icone = page.icone
		self.text = page.fullName
		self.action = nil
		self.page = page
	}
	
    var body: some View {
		Button {
			if let action = action {
				action()
			}
			else {
				swichPage(page!)
			}
		} label: {
			HStack {
				icone
					.resizable()
					.aspectRatio(contentMode: .fit)
					.foregroundColor(.primary)
				Text(text)
			}
			.frame(height: 10)
		}
		.buttonStyle(.plain)
    }
}

struct SideMenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
		Text("")
			.sideMenu(isPresented: .constant(true), size: .big, currentPage: .constant(.searchJap))
    }
}
