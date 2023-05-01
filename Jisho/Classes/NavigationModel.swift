//
//  NavigationModel.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/28.
//

import Foundation
import SwiftUI

class NavigationModel: ObservableObject {
	
	@Published var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
	
	@Published var contentCollumRoot: ContentCollumRoot? = .search
	@Published var contentCollumNavigationPath: NavigationPath = NavigationPath()
	
	@Published var detailCollumRoot: DetailCollumRoot? = nil
	@Published var detailCollumNavigationPath: NavigationPath = NavigationPath()
	
	
	var navigationsPaths: [ContentCollumRoot: (contentPath: NavigationPath,
											   detailRoot: DetailCollumRoot?,
											   detailPath: NavigationPath)] = [:]
	
	var sideMenuSelection: Binding<ContentCollumRoot?> {
		return Binding(get: { self.contentCollumRoot }) { newValue in
			
			if newValue == nil {
				if let contentCollumRoot = self.contentCollumRoot {
					self.navigationsPaths[contentCollumRoot] = (contentPath: self.contentCollumNavigationPath,
																detailRoot: self.detailCollumRoot,
																detailPath: self.detailCollumNavigationPath)
				}
			}
			else {
				self.columnVisibility = .doubleColumn
			}
			
			self.contentCollumRoot = newValue
			
			if let contentCollumRoot = self.contentCollumRoot {
				self.contentCollumNavigationPath = self.navigationsPaths[contentCollumRoot]?.contentPath ?? NavigationPath()
				self.detailCollumRoot = self.navigationsPaths[contentCollumRoot]?.detailRoot
				self.detailCollumNavigationPath = self.navigationsPaths[contentCollumRoot]?.detailPath ?? NavigationPath()
			}
		}
	}
}
