//
//  PropertyWrappers.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/31.
//

import SwiftUI
import Combine

/*
@propertyWrapper public class CloudStorage<ValueType>/*: DynamicProperty*/ {
        
    private var value: ValueType
    
    private let saveValue: (ValueType) throws -> Void
    private let readValue: () throws -> ValueType // unused
    
    var objectWillChange: (() -> Void)?

    public var wrappedValue: ValueType {
        get {
            return value
        }
        set {
            do {
                objectWillChange?()
                
                try saveValue(newValue)
                value = newValue
                
                let keyValStore = NSUbiquitousKeyValueStore.default
                if keyValStore.synchronize() == false { fatalError() }
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    public var projectedValue: Binding<ValueType> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
    
    
    private init(readValue: @escaping () throws -> ValueType, saveValue : @escaping (ValueType) throws -> Void) {
        do {
//            _value = State(wrappedValue: try readValue())
            value = try readValue()
            
            let keyValStore = NSUbiquitousKeyValueStore.default
            if keyValStore.synchronize() == false { fatalError() }
            
            
            self.saveValue = saveValue
            self.readValue =  readValue
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func actualize() {
        objectWillChange?()

        value = try! readValue()
    } // unused
    
}
*/


@propertyWrapper public struct CloudStorage<ValueType>: DynamicProperty {
        
    @State private var value: ValueType
    
    private let saveValue: (ValueType) throws -> Void
    private let readValue: () throws -> ValueType // unused
    
    public var wrappedValue: ValueType {
        get {
            return value
        }
        nonmutating set {
            do {
                try saveValue(newValue)
                value = newValue
                
                let keyValStore = NSUbiquitousKeyValueStore.default
                if keyValStore.synchronize() == false { fatalError() }
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    public var projectedValue: Binding<ValueType> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
    
    
    private init(readValue: @escaping () throws -> ValueType, saveValue : @escaping (ValueType) throws -> Void) {
        do {
            _value = State(wrappedValue: try readValue())
            
            let keyValStore = NSUbiquitousKeyValueStore.default
            if keyValStore.synchronize() == false { fatalError() }
            
            
            self.saveValue = saveValue
            self.readValue =  readValue
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func actualize() { // unused
        value = try! readValue()
    }
    
}

extension CloudStorage where ValueType == [MetaData:String?] {
    public init(wrappedValue: ValueType, _ key: String) {
        self.init(
            readValue: {
                let keyValStore = NSUbiquitousKeyValueStore.default
                let data = keyValStore.data(forKey: key)
                guard let data = data else { return wrappedValue }
                return try decodeFromCloudStorage(data)
            },
            saveValue: {
                let keyValStore = NSUbiquitousKeyValueStore.default
                let data = try encodeForCloudStorage($0)
                keyValStore.set(data, forKey: key)
            })
    }
}

extension CloudStorage where ValueType == [Langue] {
    public init(wrappedValue: ValueType, _ key: String) {
        self.init(
            readValue: {
                let keyValStore = NSUbiquitousKeyValueStore.default
                let data = keyValStore.data(forKey: key)
                guard let data = data else { return wrappedValue }
                return try decodeFromCloudStorage(data)
            },
            saveValue: {
                let keyValStore = NSUbiquitousKeyValueStore.default
                let data = try encodeForCloudStorage($0)
                keyValStore.set(data, forKey: key)
            })
    }
}

extension CloudStorage where ValueType == Set<Langue> {
    public init(wrappedValue: ValueType, _ key: String) {
        self.init(
            readValue: {
                let keyValStore = NSUbiquitousKeyValueStore.default
                let data = keyValStore.data(forKey: key)
                guard let data = data else { return wrappedValue }
                return try decodeFromCloudStorage(data)
            },
            saveValue: {
                let keyValStore = NSUbiquitousKeyValueStore.default
                let data = try encodeForCloudStorage($0)
                keyValStore.set(data, forKey: key)
            })
    }
}

extension CloudStorage where ValueType == [String] {
    public init(wrappedValue: ValueType, _ key: String) {
        self.init(
            readValue: {
                let keyValStore = NSUbiquitousKeyValueStore.default
                let data = keyValStore.data(forKey: key)
                guard let data = data else { return wrappedValue }
                return try decodeFromCloudStorage(data)
            },
            saveValue: {
                let keyValStore = NSUbiquitousKeyValueStore.default
                let data = try encodeForCloudStorage($0)
                keyValStore.set(data, forKey: key)
            })
    }
}



// Meta datas
fileprivate func encodeForCloudStorage(_ dict:[MetaData:String?]) throws -> Data {
    
    let tupleArray = dict.map { (key: MetaData, value: String?) in
        return (MetaDataStruct(key), value)
    }
    
    let dict = Dictionary(uniqueKeysWithValues: tupleArray)
    
    let encoder = JSONEncoder()
    return try encoder.encode(dict)
}

fileprivate func decodeFromCloudStorage(_ data:Data) throws -> [MetaData:String?] {
    
    
    let decoder = JSONDecoder()
    
    let dict = try decoder.decode([MetaDataStruct:String?].self, from: data)
    let tupleArray = try dict.map { (key: MetaDataStruct, value: String?) -> (MetaData, String?) in
        return try (key.getEnumFormat(), value)
    }
    
    return Dictionary(uniqueKeysWithValues: tupleArray)
}


// Langues pref
fileprivate func encodeForCloudStorage(_ langues:[Langue]) throws -> Data {
    let encoder = JSONEncoder()
    return try encoder.encode(langues)
}

fileprivate func decodeFromCloudStorage(_ data:Data) throws -> [Langue] {
        
    let decoder = JSONDecoder()
    return try decoder.decode([Langue].self, from: data)
}


// Langues affichées
fileprivate func encodeForCloudStorage(_ langues:Set<Langue>) throws -> Data {
    let encoder = JSONEncoder()
    return try encoder.encode(langues)
}

fileprivate func decodeFromCloudStorage(_ data:Data) throws -> Set<Langue> {
    
    let decoder = JSONDecoder()
    return try decoder.decode(Set<Langue>.self, from: data)
}


// Historique recherche
fileprivate func encodeForCloudStorage(_ historique:[String]) throws -> Data {
    let encoder = JSONEncoder()
    return try encoder.encode(historique)
}

fileprivate func decodeFromCloudStorage(_ data:Data) throws -> [String] {
    
    let decoder = JSONDecoder()
    return try decoder.decode([String].self, from: data)
}
