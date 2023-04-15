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
	@State var fileImporterIsPresented: Bool = false
	@State var loading: Bool = false
	
    var body: some View {
		if loading {
			ProgressView()
		}
		else if jmDictFile != nil {
			List {
				Button("Create Mots") {
					Task {
						self.loading = true
						await self.jmDictFile?.createMots()
						self.loading = false
					}
				}
				
				Button("Test") {
					Task {
						self.loading = true
						await self.jmDictFile?.test()
						self.loading = false
					}
				}
			}
		}
		else {
			VStack {
				Button("Select File") {
					fileImporterIsPresented.toggle()
				}
				.buttonStyle(.borderedProminent)
				
				Button("Use Bundle") {
					guard let path = Bundle.main.path(forResource: "JMdict", ofType: "bundle") else { return }
					let url = URL(fileURLWithPath: path + "/JMdict.json")
					Task {
						do {
							self.loading = true
							self.jmDictFile = try await JMdictFile(url)
							self.loading = false
						}
						catch {
							fatalError(error.localizedDescription)
						}
					}
				}
				.buttonStyle(.borderedProminent)
			}
			.fileImporter(isPresented: $fileImporterIsPresented,
						  allowedContentTypes: [.json],
						  allowsMultipleSelection: false,
						  onCompletion: fileSelectorCompletion)
		}
    }
	
	func fileSelectorCompletion(result: Result<[URL], Error>) {
		switch result {
		case .success(let success):
			if let url = success.first {
				Task {
					self.loading = true
					self.jmDictFile = try await JMdictFile(url)
					self.loading = false
				}
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
