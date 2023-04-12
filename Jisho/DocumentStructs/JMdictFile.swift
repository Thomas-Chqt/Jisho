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
	
	static var readableContentTypes = [UTType.xml]

	private var data:Data
	
	init(_ url: URL) {
		do {
			_ = url.startAccessingSecurityScopedResource()
			self.data = try Data(contentsOf: url)
			url.stopAccessingSecurityScopedResource()
		} catch {
			fatalError("Read file error")
		}
	}
	
	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else { throw FileError.readError }
		self.data = data
	}
	
	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		return FileWrapper(regularFileWithContents: data)
	}
	
	func parse() async {
		let xmlParser = XMLParser(data: self.data)
		let delegate = xmlParerDelegate()
		xmlParser.delegate = delegate
		xmlParser.parse()
	}
}

class xmlParerDelegate: NSObject, XMLParserDelegate {
	
	func parserDidStartDocument(_ parser: XMLParser) {
		print("Parsing start ...")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		print("Parsing finished")
	}
}
