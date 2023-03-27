//
//  MetaData_struct.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/21.
//

import Foundation

let previewTexts = ["Nom commun", "Verbe", "Adjectif", "Nom propre"]

struct MetaData_struct {
	var ID: UUID
	var text: String?
	
	init(ID: UUID? = nil, text: String? = nil) {
		self.ID = ID ?? UUID()
		self.text = text
	}
	
	init(_ type: InitType) {
		switch type {
		case .empty:
			self.ID = UUID()
			self.text = nil
		case .preview:
			self.ID = UUID()
			self.text = previewTexts.randomElement()
		}
	}
}
