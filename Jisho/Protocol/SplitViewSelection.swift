//
//  SplitViewSelection.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/02.
//

import Foundation
import SwiftUI

protocol SplitViewSelection: Hashable {
	associatedtype V: View
	
	var view: V { get }
}
