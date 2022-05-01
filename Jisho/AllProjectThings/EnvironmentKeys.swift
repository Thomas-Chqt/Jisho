//
//  EnvironmentKeys.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/04/29.
//

import Foundation
import SwiftUI


private struct SwitchPageEnvironmentKey: EnvironmentKey {
    
    typealias Value = (Page) -> Void
    
    static var defaultValue: (Page) -> Void = {_ in }
}

extension EnvironmentValues {
  var switchPage: (Page) -> Void {
    get { self[SwitchPageEnvironmentKey.self] }
    set { self[SwitchPageEnvironmentKey.self] = newValue }
  }
}



private struct ToggleSideMenuEnvironmentKey: EnvironmentKey {
    
    typealias Value = () -> Void
    
    static var defaultValue: () -> Void = { }
}

extension EnvironmentValues {
  var toggleSideMenu: () -> Void {
    get { self[ToggleSideMenuEnvironmentKey.self] }
    set { self[ToggleSideMenuEnvironmentKey.self] = newValue }
  }
}



private struct LanguePrefEnvironmentKey: EnvironmentKey {
    
    static var defaultValue: CloudStorage<[Langue]> = CloudStorage(wrappedValue: languesPrefOriginal, "languesPrefData")
}

extension EnvironmentValues {
  var languesPref: CloudStorage<[Langue]> {
    get { self[LanguePrefEnvironmentKey.self] }
    set { self[LanguePrefEnvironmentKey.self] = newValue }
  }
}



private struct LanguesAffichesEnvironmentKey: EnvironmentKey {
    
    static var defaultValue: CloudStorage<Set<Langue>> = CloudStorage(wrappedValue: languesAffichéesOriginal, "languesAfficheesData")
}

extension EnvironmentValues {
  var languesAffichées: CloudStorage<Set<Langue>> {
    get { self[LanguesAffichesEnvironmentKey.self] }
    set { self[LanguesAffichesEnvironmentKey.self] = newValue }
  }
}



private struct MetaDataDictEnvironmentKey: EnvironmentKey {
    
    static var defaultValue: CloudStorage<[MetaData : String?]> = CloudStorage(wrappedValue: metaDataDictOriginal, "metaDataDictData")
}

extension EnvironmentValues {
  var metaDataDict: CloudStorage<[MetaData : String?]> {
    get { self[MetaDataDictEnvironmentKey.self] }
    set { self[MetaDataDictEnvironmentKey.self] = newValue }
  }
}


/*
private struct SearchHistoryEnvironmentKey: EnvironmentKey {
    
    static var defaultValue: CloudStorage<[MetaData : String?]> = CloudStorage(wrappedValue: metaDataDictOriginal, "metaDataDictData")
}

extension EnvironmentValues {
  var metaDataDict: CloudStorage<[MetaData : String?]> {
    get { self[MetaDataDictEnvironmentKey.self] }
    set { self[MetaDataDictEnvironmentKey.self] = newValue }
  }
}
*/
