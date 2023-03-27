//
//  DebugPageViewModel.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

class DebugPageViewModel: ObservableObject {
	@Published var selection:NSManagedObjectType?
	@Published var showFileExporter = false
	
	var fileExporterContent: (document: SQLiteFile?,
							  type: UTType,
							  filename: String,
							  completion: (Result<URL, Error>) -> Void) = ( nil, UTType.text, "", {_ in} )

	init() {}
	
	func exportSQLiteFile() {
		self.fileExporterContent = (
			SQLiteFile(DataController.localStoreLocationSQLite),
			UTType("jisho.fileType.sqlite")!,
			"local",
			{ _ in }
		)
		showFileExporter.toggle()
	}
	
	func exportSQLiteSHMFile() {
		self.fileExporterContent = (
			SQLiteFile(DataController.localStoreLocationSQLiteSHM),
			UTType("jisho.fileType.sqlite-shm")!,
			"local",
			{ _ in }
		)
		showFileExporter.toggle()
	}
	
	func exportSQLiteWALFile() {
		self.fileExporterContent = (
			SQLiteFile(DataController.localStoreLocationSQLiteWAL),
			UTType("jisho.fileType.sqlite-wal")!,
			"local",
			{ _ in }
		)
		showFileExporter.toggle()
	}
}
