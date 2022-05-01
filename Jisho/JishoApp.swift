//
//  JishoApp.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/02.
//

import SwiftUI
import CoreData

@main
struct JishoApp: App {
    
    @StateObject private var dataController = DataController.shared
    
    var body: some Scene
    {
        WindowGroup
        {
            switch dataController.loadingStatus {
                
                
            case nil:
                EmptyView()
                
            case .loading:
                ProgressView()
            
            case .loadingPercent(let description, let percent):
                VStack {
                    Text("\(description) - \(percent)%")
                    ProgressView()
                }
                
            case .finished:
                    ContentView()
                        .environment(\.managedObjectContext, dataController.mainQueueManagedObjectContext)
            }
        }
    }
}
