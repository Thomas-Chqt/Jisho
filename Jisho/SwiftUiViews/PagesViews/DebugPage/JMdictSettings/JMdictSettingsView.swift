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
	@State var metaDataFile: MetaDatasFile? = nil
	
	@State var jmDictFilePickerIsShow: Bool = false
	@State var metaDataFilePickerIsShow: Bool = false
	@State var loading: Bool = false
	
    var body: some View {
		if loading {
			ProgressView()
		}
		else
		{
			List {
				Section("JMdict File") {
					if let jmDictFile = jmDictFile {
						Button("Create Mots") {
							Task {
								do {
									self.loading = true
									try await jmDictFile.createMots()
									self.loading = false
								} catch { fatalError(error.localizedDescription) }
								
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
					else {
						HStack {
							Button("File Picker") {
								jmDictFilePickerIsShow.toggle()
							}
							.buttonStyle(.borderedProminent)
							
							Spacer()
							
							Button("Use Bundle") {
								guard let path = Bundle.main.path(forResource: "JMdict", ofType: "bundle") else { return }
								let url = URL(fileURLWithPath: path + "/JMdict_FR.json")
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
						.padding(.horizontal)
					}
				}
				
				Section("MetaDatas File") {
					if let metaDataFile = metaDataFile {
						Button("Create MetaDatas") {
							Task {
								self.loading = true
								await metaDataFile.createMetaData()
								self.loading = false
							}
						}
					}
					else {
						HStack {
							Button("File Picker") {
								metaDataFilePickerIsShow.toggle()
							}
							.buttonStyle(.borderedProminent)
							
							Spacer()
							
							Button("Use Bundle") {
								guard let path = Bundle.main.path(forResource: "JMdict", ofType: "bundle") else { return }
								let url = URL(fileURLWithPath: path + "/MetaDatas.json")
								Task {
									do {
										self.loading = true
										self.metaDataFile = try await MetaDatasFile(url)
										self.loading = false
									}
									catch {
										fatalError(error.localizedDescription)
									}
								}
							}
							.buttonStyle(.borderedProminent)
						}
						.padding(.horizontal)
					}
				}
			}
			.fileImporter(isPresented: $jmDictFilePickerIsShow,
						  allowedContentTypes: [.json],
						  allowsMultipleSelection: false,
						  onCompletion: jmdictFilePickerCompletion)
			
			.fileImporter(isPresented: $metaDataFilePickerIsShow,
						  allowedContentTypes: [.json],
						  allowsMultipleSelection: false,
						  onCompletion: metaDataFilePickerCompletion)
		}
    }
	
	func jmdictFilePickerCompletion(result: Result<[URL], Error>) {
		switch result {
		case .success(let success):
			if let url = success.first {
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
		case .failure(let failure):
			print(failure.localizedDescription)
		}
	}
	
	
	func metaDataFilePickerCompletion(result: Result<[URL], Error>) {
		switch result {
		case .success(let success):
			if let url = success.first {
				Task {
					do {
						self.loading = true
						self.metaDataFile = try await MetaDatasFile(url)
						self.loading = false
					}
					catch {
						fatalError(error.localizedDescription)
					}
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
