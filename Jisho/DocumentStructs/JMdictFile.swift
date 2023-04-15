//
//  JMdictFile.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/12.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct JMdictFile: FileDocument {
	
	static var readableContentTypes = [UTType.json]

	private var jsonData: [json_Entry]
	
	init(_ url: URL) async throws {
		_ = url.startAccessingSecurityScopedResource()
		let data = try Data(contentsOf: url)
		url.stopAccessingSecurityScopedResource()
		self.jsonData = try JSONDecoder().decode([json_Entry].self, from: data)
	}
	
	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else { throw FileError.readError }
		self.jsonData = try JSONDecoder().decode([json_Entry].self, from: data)
	}
	
	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = try JSONSerialization.data(withJSONObject: jsonData)
		return FileWrapper(regularFileWithContents: data)
	}
	
	func createMots() async {
		await DataController.shared.privateQueueManagedObjectContext.perform {
			for (i, entry) in jsonData.enumerated() {
				_ = Mot(entry: entry, context: DataController.shared.privateQueueManagedObjectContext)
				if (i + 1) % (jsonData.count / 100) == 0 {
					print("\((i + 1) / (jsonData.count / 100))")
				}
			}
			DataController.shared.save()
		}
	}
	
	func test() async {
//		for entry in jsonData {
//			for sense in entry.senses {
//				for glos in sense.gloss {
//					if glos.value == nil {
//						print(entry.ent_seq)
//					}
//				}
//			}
//		}
	}
}


struct json_Gloss: Codable {
	var g_type: String?
	var g_gend: String?
	var lang: String?
	var value: String
}

struct json_Lsource: Codable {
	var lang: String?
	var ls_type: String?
	var ls_wasei: String?
	var value: String?
}

struct json_Sense: Codable {
	var stagk: [String]
	var stagr: [String]
	var xref: [String]
	var ant: [String]
	var pos: [String]
	var field: [String]
	var misc: [String]
	var s_inf: [String]
	var lsource: [json_Lsource]
	var gloss: [json_Gloss]
}

struct json_R_ele: Codable {
	var reb: String
	var re_nokanji: Bool
	var re_restr: [String]
	var re_inf: [String]
	var re_pri: [String]
}

struct json_K_ele: Codable {
	var keb: String
	var ke_inf: [String]
	var ke_pri: [String]
}

struct json_Entry: Codable {
	var ent_seq: Int
	var k_eles: [json_K_ele]
	var r_eles: [json_R_ele]
	var senses: [json_Sense]
	
	var senseDict: [Langue:[json_Sense]] {
		var outputDict: [Langue:[json_Sense]] = [:]
		
		for sense in senses {
			if !sense.gloss.allSatisfy({ gloss in gloss.lang == sense.gloss.first?.lang }) {
				fatalError("different languages in same sense glosses")
			}
			
			guard let langue = Langue(rawValue: sense.gloss.first?.lang ?? "") else {
				fatalError("unknown language : \"\(sense.gloss.first?.lang ?? "")\"")
			}
			
			outputDict[langue] = (outputDict[langue] ?? []) + [sense]
		}
			
		return outputDict
	}
}
