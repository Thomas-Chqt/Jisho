//
//  DebugPageViewModel.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import CoreData

class DebugPageViewModel: ObservableObject {
	@Published var selection: Entity?
	@Published var showFileExporter = false
	

	
	var fileExporterContent: (document: SQLiteFile?,
							  type: UTType,
							  filename: String,
							  completion: (Result<URL, Error>) -> Void) = ( nil, UTType.text, "", {_ in} )
}

extension DebugPageViewModel: FileExporterDelegate {
	
	var isPresented: Binding<Bool> { Binding(get: { [self] in showFileExporter }, set: { self.showFileExporter = $0 })}
	var document: SQLiteFile? { fileExporterContent.document }
	var contentType: UTType { fileExporterContent.type }
	var defaultFilename: String? { fileExporterContent.filename }
	var onCompletion: (Result<URL, Error>) -> Void { fileExporterContent.completion }
	
	
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
