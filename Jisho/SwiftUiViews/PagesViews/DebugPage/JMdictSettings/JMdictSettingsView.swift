//
//  JMdictSettingsView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/12.
//

import SwiftUI
import UniformTypeIdentifiers

struct JMdictSettingsView: View {
	
	@State var jmDictFile: JMdictFile? = nil
	@State var fileImporterIsPresented: Bool = true
	@State var loading: Bool = false
	
    var body: some View {
		if loading {
			ProgressView()
		}
		else if let jmDictFile = jmDictFile {
			List {
				Button("Parse") {
					Task {
						self.loading = true
						await jmDictFile.parse()
						self.loading = false
					}
					
				}
			}
		}
		else {
			Button("Select File") {
				fileImporterIsPresented.toggle()
			}
			.buttonStyle(.borderedProminent)
			.fileImporter(isPresented: $fileImporterIsPresented,
						  allowedContentTypes: [.xml],
						  allowsMultipleSelection: true,
						  onCompletion: fileSelectorCompletion)
		}
    }
	
	func fileSelectorCompletion(result: Result<[URL], Error>) {
		switch result {
		case .success(let success):
			if let url = success.first {
				self.jmDictFile = JMdictFile(url)
			}
		case .failure(let failure):
			print(failure.localizedDescription)
		}
	}
}

struct JMdictSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        JMdictSettingsView()
    }
}
