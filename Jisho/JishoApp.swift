//
//  JishoApp.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/02.
//

import SwiftUI

@main
struct JishoApp: App {
    var body: some Scene
    {
        WindowGroup
        {
			#if os(iOS)
			ContentView_iOS()
			#endif
			#if os(macOS)
			ContentView_macOS()
			#endif
        }
    }
}
