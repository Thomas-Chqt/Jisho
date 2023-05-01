//
//  ViewExtensions.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/16.
//

import Foundation
import SwiftUI

extension View {
	func menuButton<Content : View>(@ViewBuilder content: () -> Content) -> some View  {
		self
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Menu(content: content) {
						Image(systemName: "ellipsis.circle")
					}
				}
			}
	}
}

extension View {
	func fileExporter<Delegate: FileExporterDelegate>(_ delegate: Delegate) -> some View {
		self.fileExporter(isPresented: delegate.isPresented,
						  document: delegate.document,
						  contentType: delegate.contentType,
						  defaultFilename: delegate.defaultFilename,
						  onCompletion: delegate.onCompletion)
	}
}
