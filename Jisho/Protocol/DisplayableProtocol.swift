//
//  DisplayableProtocol.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/28.
//

import Foundation

protocol Displayable {
	var primary: String? { get }
	var secondary: String? { get }
	var details: String? { get }
}

extension Displayable {
	var primary: String? {
		return nil
	}
	
	var secondary: String? {
		return nil
	}
	
	var details: String? {
		return nil
	}
}
