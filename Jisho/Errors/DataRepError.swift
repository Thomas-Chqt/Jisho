//
//  DataRepresentationError.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/05.
//

import Foundation

enum DataRepError: Error {
	case NilPersStoreCoor
	case ObjIDNotFound
	case ObjNotFound
}
