//
//  JishoApp.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/02.
//

import SwiftUI
import CoreData

public class Settings: ObservableObject {
    @PublishedCloudStorage("languesPrefData") var languesPref:[Langue] = languesPrefOriginal
    @PublishedCloudStorage("metaDataDictData") var metaDataDict:[MetaData : String?] = metaDataDictOriginal
    @PublishedCloudStorage("languesAfficheesData") var languesAffichées:Set<Langue> = languesAffichéesOriginal
    
    static var performRealSearch = false
}

@main
struct JishoApp: App {
    
    @StateObject private var dataController = DataController.shared
    @StateObject var settings = Settings()
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environment(\.managedObjectContext, dataController.mainQueueManagedObjectContext)
                .environmentObject(settings)
        }
    }
}
