//
//  MetaDataPickerView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/04.
//

import SwiftUI

struct MetaDataPickerSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.metaDataDict) var metaDataDict
    
    @Binding var selectedMetaData: MetaData
    
    var body: some View {
        NavigationView {
            MetaDataListView { metaData in
                Button(metaData.description(metaDataDict.wrappedValue)) {
                    selectedMetaData = metaData
                    dismiss()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}



/*
struct MetaDataPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MetaDataPickerView()
    }
}
*/
