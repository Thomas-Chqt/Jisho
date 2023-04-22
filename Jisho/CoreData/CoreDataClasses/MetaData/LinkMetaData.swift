//
//  LinkMetaData.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/21.
//
//

import Foundation
import CoreData

@objc(LinkMetaData)
public class LinkMetaData: MetaData {

	//MARK: FetchRequests
	@nonobjc public class func fetchRequest() -> NSFetchRequest<LinkMetaData> {
		return NSFetchRequest<LinkMetaData>(entityName: "LinkMetaData")
	}
	
	//MARK: NSManaged attributs
	@NSManaged public var linkedSense_atb: Sense?
	@NSManaged public var parent_atb: Sense?
	
	//MARK: EasyInit's init
	convenience required init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		
		switch type {
		case .empty:
			self.init(id: nil, context: context)
		case .preview:
			self.init(text: "Link metaData \(Int.random(in: 1...4))", context: context)
		}
	}
}

//MARK: Protocole extentions
extension LinkMetaData: EasyInit {}
