//
//  UniqueMetaData.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/21.
//
//

import Foundation
import CoreData

@objc(UniqueMetaData)
public class UniqueMetaData: MetaData {
	
	//MARK: FetchRequests
	@nonobjc public class func fetchRequest() -> NSFetchRequest<UniqueMetaData> {
		return NSFetchRequest<UniqueMetaData>(entityName: "UniqueMetaData")
	}
	
	//MARK: NSManaged attributs
	@NSManaged public var parent_atb: Sense?
	
	//MARK: EasyInit's init
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		
		switch type {
		case .empty:
			self.init(context: context)
		case .preview:
			self.init(text: "Unique metaData \(Int.random(in: 1...4))", context: context)
		}
	}
	
}

//MARK: Protocole extentions
extension UniqueMetaData: EasyInit {}
