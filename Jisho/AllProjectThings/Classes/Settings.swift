//
//  Settings.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/13.
//

import Foundation


class Settings: ObservableObject {
    @PublishedCloudStorage("languesPrefData") var languesPref:[Langue] = languesPrefOriginal
    @PublishedCloudStorage("metaDataDictData") var metaDataDict:[MetaData : String?] = metaDataDictOriginal
    @PublishedCloudStorage("languesAfficheesData") var languesAffichées:Set<Langue> = languesAffichéesOriginal
}
