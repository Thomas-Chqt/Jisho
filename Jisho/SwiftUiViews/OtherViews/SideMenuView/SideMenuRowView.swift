//
//  SideMenuRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import SwiftUI

struct SideMenuRowView: View {
	
	var value: AppPages
	
    var body: some View {
		NavigationLink(value: value) {
			HStack {
				value.icone
				Text(value.fullName)
			}
		}
    }
}

struct SideMenuRowView_Previews: PreviewProvider {
    static var previews: some View {
		SideMenuRowView(value: .search)
    }
}
