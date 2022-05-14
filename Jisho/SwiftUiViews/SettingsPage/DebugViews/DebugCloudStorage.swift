//
//  DebugCloudStorage.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/31.
//

import SwiftUI

fileprivate class DebugCloudStorageViewModel: ObservableObject {
    
    @PublishedCloudStorage("searchHistory") var searchHistory:[String] = []
}

struct DebugCloudStorage: View {
        
//    @Environment(\.languesPref) var languesPref
    @EnvironmentObject private var settings: Settings
    
    @StateObject private var vm = DebugCloudStorageViewModel()
    
    var body: some View
    {
        List {
            ForEach(vm.searchHistory, id:\.self) { keyword in
                Text(keyword)
            }
            .onDelete { indexs in
                indexs.forEach { index in
                    vm.searchHistory.remove(at: index)
                }
            }
        }
    }
}

struct DebugCloudStorage_Previews: PreviewProvider {
    static var previews: some View {
        DebugCloudStorage()
    }
}
