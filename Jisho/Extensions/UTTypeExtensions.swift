//
//  UTTypeExtensions.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/05.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
	static var entity: UTType { UTType(exportedAs: "jisho.ObjType.Entity") }
	
	static var liste: UTType { UTType(exportedAs: "jisho.ObjType.Liste") }
	
	static var traduction: UTType { UTType(exportedAs: "jisho.ObjType.Traduction") }
	
	static var mot: UTType { UTType(exportedAs: "jisho.ObjType.Mot") }
	
	static var motWithSrcListe: UTType { UTType(exportedAs: "jisho.ObjType.MotWithSrcListe") }
}
