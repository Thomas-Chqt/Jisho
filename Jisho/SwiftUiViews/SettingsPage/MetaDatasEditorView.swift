//
//  MetaDatasEditorView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/04.
//

import SwiftUI

struct MetaDatasEditorView: View {
    
//    @Environment(\.metaDataDict) var metaDataDict
    @EnvironmentObject private var settings: Settings

    var body: some View
    {
        MetaDataListView() { metaData in
            TextField(metaDataDictOriginal[metaData] ?? "", text: Binding( get: { metaData.description(settings.metaDataDict) },
                                                                           set: { settings.metaDataDict[metaData] = $0 }))
        }
        .toolbar { ToolbarItem(placement: .navigationBarTrailing, content: { menuButton }) }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    var menuButton: some View
    {
        Menu
        {
            Button("Reset")
            {
                settings.metaDataDict = metaDataDictOriginal
            }
        }
        label:
        {
            Image(systemName: "ellipsis.circle")
        }
        .padding([.leading,.bottom,.top])
    }
}



struct MetaDatasEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MetaDatasEditorView()
        }
    }
}
