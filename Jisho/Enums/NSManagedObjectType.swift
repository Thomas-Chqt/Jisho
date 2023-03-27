//
//  NSManagedObjectType.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/22.
//

import Foundation
import CoreData


enum NSManagedObjectType {
	case metaData
	
	
	var type: NSManagedObject.Type {
		switch self {
		case .metaData:
			return MetaData.self
		}
	}
	
	var description: String {
		switch self {
		case .metaData:
			return "MetaData"
		}
	}
}
