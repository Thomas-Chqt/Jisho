//
//  Functions.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/22.
//

import Foundation
import CoreData


func getApplicationSupportDirectory() -> URL {
    let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getDocumentDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}






func breakString(_ str:String) -> Set<String> {
    
    var stringSet: Set<String> = []
    
    for i in 0..<str.count {
        
        let startIndex = str.index(str.startIndex, offsetBy: i)
        
        for y in i..<str.count {
            
            let endIndex = str.index(str.startIndex, offsetBy: y)
                    
            let subcript = str[startIndex...endIndex]
            
            stringSet.insert(String(subcript))
        }
    }
    
    return stringSet
}


func getKeyWords(_ mot: Mot) -> Set<String> {
    
    var keyWordSet: Set<String> = []
    
    for japonai in mot.japonais ?? [] {
        if let kanji = japonai.kanji { keyWordSet.formUnion(breakString(kanji)) }
        if let kana = japonai.kana { keyWordSet.formUnion(breakString(kana)) }
    }
    
    for sense in mot.senses ?? [] {
        for trad in sense.traductionsArray ?? [] {
            if let traductions = trad.traductions { keyWordSet.formUnion(traductions) }
        }
    }
    
    for trad in mot.noSenseTradsArray ?? [] {
        if let traductions = trad.traductions { keyWordSet.formUnion(traductions) }
    }
    
    return keyWordSet
    
}
