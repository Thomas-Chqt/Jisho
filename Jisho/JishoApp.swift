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
	@StateObject private var settings = Settings.shared
	@State var isDragEnable = true
	@StateObject var myDispatchQueue = MyDispatchQueue()
	
    var body: some Scene
    {
        WindowGroup
        {
			ContentView()
				.environment(\.managedObjectContext, dataController.mainQueueManagedObjectContext)
				.environmentObject(settings)
				.environment(\.isDragEnable, $isDragEnable)
				.environmentObject(myDispatchQueue)
        }
    }
}
