//
//  DebugPageNavigationModel.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import Foundation
import SwiftUI

class DebugPageNavigationModel: NavigationModel {
	@Published var selection: DebugPageSelection? = nil
}
