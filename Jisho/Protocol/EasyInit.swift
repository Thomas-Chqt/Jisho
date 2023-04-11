//
//  EasyInit.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/30.
//

import Foundation
import CoreData

protocol EasyInit {
	init(_ type: InitType, context: NSManagedObjectContext?)
}
