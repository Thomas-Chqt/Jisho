//
//  FileExporterDelegate.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/30.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

protocol FileExporterDelegate {
	associatedtype Document: FileDocument

	var isPresented: Binding<Bool> { get }
	var document: Document? { get }
	var contentType: UTType { get }
	var defaultFilename: String? { get }
	var onCompletion: (Result<URL, Error>) -> Void { get }
}
