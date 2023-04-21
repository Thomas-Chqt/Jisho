//
//  MetaDatasFile.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/20.
//

import Foundation

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct MetaDatasFile: FileDocument {
	
	static var readableContentTypes = [UTType.json]
	
	private var jsonData: [json_MetaData]
	
	init(_ url: URL) async throws {
		_ = url.startAccessingSecurityScopedResource()
		let data = try Data(contentsOf: url)
		url.stopAccessingSecurityScopedResource()
		self.jsonData = try JSONDecoder().decode([json_MetaData].self, from: data)
	}
	
	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else { throw FileError.readError }
		self.jsonData = try JSONDecoder().decode([json_MetaData].self, from: data)
	}
	
	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = try JSONSerialization.data(withJSONObject: jsonData)
		return FileWrapper(regularFileWithContents: data)
	}
	
	func createMetaData() async {
		await DataController.shared.privateQueueManagedObjectContext.perform {
			for (i, metaData) in jsonData.enumerated() {
				_ = MetaData(jsonMetaData: metaData, context: DataController.shared.privateQueueManagedObjectContext)
				if (i + 1) % (jsonData.count / 100) == 0 {
					print("\((i + 1) / (jsonData.count / 100))")
				}
			}
			DataController.shared.save()
		}
	}
	
	func test() async {
		
	}
	
}

struct json_MetaData: Codable {
	var fr: String
	var en: String
}
