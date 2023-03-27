//
//  MetaData+CoreDataClass.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/21.
//
//

import Foundation
import CoreData

@objc(MetaData)
public class MetaData: NSManagedObject, Identifiable {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<MetaData> {
		return NSFetchRequest<MetaData>(entityName: "MetaData")
	}
	
	@NSManaged private var id_atb: UUID?
	@NSManaged private var text_atb: String?
	
	var ID: UUID {
		get { id_atb! }
		set { id_atb = newValue }
	}
	
	var text: String? {
		get {
			if text_atb == nil || text_atb == "" || text_atb == " " {
				return nil
			}
			return text_atb
		}
		set { text_atb = newValue }
	}
	
	
	private convenience init(ID: UUID? = nil, text: String? = nil, context: NSManagedObjectContext) {
		self.init(context: context)
		self.ID = ID ?? UUID()
		self.text = text
	}
	
	convenience init(struct metaDataStruct: MetaData_struct?, context: NSManagedObjectContext) {
		self.init(ID: metaDataStruct?.ID, text: metaDataStruct?.text, context: context)
	}
	
	convenience init(_ type: InitType, context: NSManagedObjectContext? = nil) {
		self.init(struct: MetaData_struct(type), context: context ?? DataController.shared.mainQueueManagedObjectContext)
	}
}
