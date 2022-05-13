//
//  MetaDataRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/31.
//

import SwiftUI

struct MetaDataRowView<Content: View>: View {

//    @Environment(\.metaDataDict) var metaDataDict
    @EnvironmentObject private var settings: Settings
    
    var metaData: MetaData
    var content: (String) -> Content
    
    var body: some View {
        content(metaData.description(settings.metaDataDict))
    }
}

//struct MetaDataRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        MetaDataRowView()
//    }
//}
