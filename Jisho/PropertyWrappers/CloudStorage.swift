//
//  CloudStorage.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/07.
//

import Foundation
import SwiftUI
import Combine


@propertyWrapper struct CloudStorage<ValueType> where ValueType: Codable {
	
	static public subscript<T: ObservableObject>( _enclosingInstance instance: T,
												  wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, ValueType>,
												  storage storageKeyPath: ReferenceWritableKeyPath<T, Self> ) -> ValueType {
		get {
			instance[keyPath: storageKeyPath].readValue()
		}
		set {
			let publisher = instance.objectWillChange as! ObservableObjectPublisher
			publisher.send()
			
			instance[keyPath: storageKeyPath].writeValue(newValue)
		}
	}
	
	private var key: String
	private var value: ValueType
	
	private func readValue() -> ValueType {
		do {
			let keyValStore = NSUbiquitousKeyValueStore.default
			let data = keyValStore.data(forKey: key)
			guard let data = data else { return self.value }
			return try decodeFromCloudStorage(data)
		}
		catch {
			fatalError(error.localizedDescription)
		}
	}
	
	private func writeValue(_ newValue: ValueType) {
		do {
			let keyValStore = NSUbiquitousKeyValueStore.default
			let data = try encodeForCloudStorage(newValue)
			keyValStore.set(data, forKey: key)
		}
		catch {
			fatalError(error.localizedDescription)
		}
	}
	
	
	private func encodeForCloudStorage(_ value: ValueType) throws -> Data {
		let encoder = JSONEncoder()
		return try encoder.encode(value)
	}
	
	private func decodeFromCloudStorage(_ data: Data) throws -> ValueType {
		let decoder = JSONDecoder()
		return try decoder.decode(ValueType.self, from: data)
	}
	
	
	
	init(wrappedValue: ValueType, _ key: String) {
		self.value = wrappedValue
		self.key = key
	}
	
	
	@available(*, unavailable, message: "@CloudStorage can only be applied to classes" )
	
	public var wrappedValue: ValueType {
		get { fatalError() }
		set { fatalError() }
	}
}



