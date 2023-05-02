//
//  NavigationModel.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import Foundation
import SwiftUI

protocol NavigationModel: ObservableObject {
	associatedtype S: SplitViewSelection
	
	var selection: S? { get }
}
