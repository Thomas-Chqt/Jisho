//
//  StringExtensions.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/04.
//

import Foundation

extension String: Identifiable {
	public typealias ID = Int
	public var id: Int {
		return hash
	}
}
