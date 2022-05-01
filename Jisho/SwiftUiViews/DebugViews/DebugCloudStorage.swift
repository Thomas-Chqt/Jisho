//
//  DebugCloudStorage.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/31.
//

import SwiftUI

struct DebugCloudStorage: View {
        
    @Environment(\.languesPref) var languesPref
    
    
    var body: some View
    {
        List {
            ForEach(languesPref.wrappedValue, id:\.self) { langue in
                Text(langue.fullName)
            }
            Button {
                languesPref.wrappedValue = languesPref.wrappedValue.shuffled()
            } label: {
                Text("Shuffle")
            }
        }
    }
}

struct DebugCloudStorage_Previews: PreviewProvider {
    static var previews: some View {
        DebugCloudStorage()
    }
}
