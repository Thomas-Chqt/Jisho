//
//  Settings.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/07.
//

import Foundation
import SwiftUI


class Settings: ObservableObject {
	
	static let shared = Settings()
	static let defaulSselectedLangues = Set(Langue.allUsableCases)
	static let defaulLangueOrder = Langue.allUsableCases

	
	@CloudStorage("selectedLangues") var selectedLangues: Set<Langue> = defaulSselectedLangues
	@CloudStorage("langueOrder") var langueOrder: [Langue] = defaulLangueOrder
	
	@objc func onUbiquitousKeyValueStoreDidChangeExternally(notification: Notification)
	{
		print("onUbiquitousKeyValueStoreDidChangeExternally")
		DispatchQueue.main.async {
			self.objectWillChange.send()
		}
	}
	
	init() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(onUbiquitousKeyValueStoreDidChangeExternally(notification:)),
											   name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
											   object: NSUbiquitousKeyValueStore.default)
	}
}
