//
//  structs.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/17.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct MetaDataStruct: Codable, Hashable {
    var type:String
    var key:String
    
    init(type:String, key:String) {
        self.type = type
        self.key = key
    }
    
    init(_ enum_:MetaData) {
        switch enum_ {
        case .pos(let metaDataKey):
            self.type = "pos"
            self.key = metaDataKey.rawValue
        case .ke_pri(let string):
            self.type = "ke_pri"
            self.key = string
        case .re_pri(let string):
            self.type = "re_pri"
            self.key = string
        case .misc(let metaDataKey):
            self.type = "misc"
            self.key = metaDataKey.rawValue
        case .ke_inf(let metaDataKey):
            self.type = "ke_inf"
            self.key = metaDataKey.rawValue
        case .dial(let metaDataKey):
            self.type = "dial"
            self.key = metaDataKey.rawValue
        case .re_inf(let metaDataKey):
            self.type = "re_inf"
            self.key = metaDataKey.rawValue
        case .field(let metaDataKey):
            self.type = "field"
            self.key = metaDataKey.rawValue
        case .s_inf(let string):
            self.type = "s_inf"
            self.key = string
        case .stagk(let string):
            self.type = "stagk"
            self.key = string
        case .stagr(let string):
            self.type = "stagr"
            self.key = string
        case .xref(let string):
            self.type = "xref"
            self.key = string
        case .ant(let string):
            self.type = "ant"
            self.key = string
        case .perso(let string):
            self.type = "perso"
            self.key = string
        }
    }
    
    func getEnumFormat() throws -> MetaData {
        
        switch type
        {
        case "xref":
            return .xref(key)
            
        case "pos":
            if let metaDataKey = MetaDataKey(rawValue: key) {
                return .pos(metaDataKey)
            }
            else {
                throw ErrorPerso.keyInconnue
            }
            
        case "ke_pri":
            return .ke_pri(key)
            
        case "re_pri":
            return .re_pri(key)
            
        case "misc":
            if let metaDataKey = MetaDataKey(rawValue: key) {
                return .misc(metaDataKey)
            }
            else {
                throw ErrorPerso.keyInconnue
            }
            
        case "ke_inf":
            if let metaDataKey = MetaDataKey(rawValue: key) {
                return .ke_inf(metaDataKey)
            }
            else {
                throw ErrorPerso.keyInconnue
            }
            
        case "dial":
            if let metaDataKey = MetaDataKey(rawValue: key) {
                return .dial(metaDataKey)
            }
            else {
                throw ErrorPerso.keyInconnue
            }
            
        case "s_inf":
            return .s_inf(key)
            
        case "stagk":
            return .stagk(key)
            
        case "re_inf":
            if let metaDataKey = MetaDataKey(rawValue: key) {
                return .re_inf(metaDataKey)
            }
            else {
                throw ErrorPerso.keyInconnue
            }
            
        case "stagr":
            return .stagr(key)
            
        case "field":
            if let metaDataKey = MetaDataKey(rawValue: key) {
                return .field(metaDataKey)
            }
            else {
                throw ErrorPerso.keyInconnue
            }
            
        case "ant":
            return .ant(key)
            
        default:
            throw ErrorPerso.metaDataTypeInconnu
        }
    }
}
