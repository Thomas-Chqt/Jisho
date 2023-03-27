//
//  SQLiteFile.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct SQLiteFile: FileDocument {
	static var readableContentTypes = [UTType("jisho.fileType.sqlite")!,
									   UTType("jisho.fileType.sqlite-shm")!,
									   UTType("jisho.fileType.sqlite-wal")!]
	
	private var data:Data
	
	init(_ url: URL) {
		do {
			self.data = try Data(contentsOf: url)
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
}

//struct SQLiteSHMFile: FileDocument {
//	static var readableContentTypes = [UTType("jisho.fileType.sqlite-shm")!]
//
//	private var data:Data
//
//	init(_ url: URL) {
//		do {
//			self.data = try Data(contentsOf: url)
//		} catch {
//			fatalError("Read file error")
//		}
//	}
//
//	init(configuration: ReadConfiguration) throws {
//		guard let data = configuration.file.regularFileContents else { throw FileError.readError }
//		self.data = data
//	}
//
//	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
//		return FileWrapper(regularFileWithContents: data)
//	}
//}
//
//struct SQLiteWALFile: FileDocument {
//	static var readableContentTypes = [UTType("jisho.fileType.sqlite-wal")!]
//
//	private var data:Data
//
//	init(_ url: URL) {
//		do {
//			self.data = try Data(contentsOf: url)
//		} catch {
//			fatalError("Read file error")
//		}
//	}
//
//	init(configuration: ReadConfiguration) throws {
//		guard let data = configuration.file.regularFileContents else { throw FileError.readError }
//		self.data = data
//	}
//
//	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
//		return FileWrapper(regularFileWithContents: data)
//	}
//}
