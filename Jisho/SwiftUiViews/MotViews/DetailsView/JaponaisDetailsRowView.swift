//
//  JaponaisDetailsRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/31.
//

import SwiftUI

struct JaponaisDetailsRowView: View {
    
    var jap:Japonais
    
    var body: some View
    {
        VStack
        {
            if let kana = jap.kana
            {
                Text(kana)
                    .font(jap.kanji != nil ? .body : .largeTitle)
                    .fontWeight(jap.kanji != nil ? .light : .regular)
            }
            
            if let kanji = jap.kanji
            {
                Text(kanji)
                    .font(.largeTitle)
            }
        }
        .padding(.vertical, 6.0)
    }
}

//struct JaponaisDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        JaponaisDetailsView()
//    }
//}
