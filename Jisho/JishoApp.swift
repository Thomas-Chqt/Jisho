//
//  JishoApp.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/02.
//

import SwiftUI

@main
struct JishoApp: App {
	
	@StateObject private var dataController = DataController.shared
	
    var body: some Scene
    {
        WindowGroup
        {
			ContentView()
				.environment(\.managedObjectContext, dataController.mainQueueManagedObjectContext)
        }
    }
}
