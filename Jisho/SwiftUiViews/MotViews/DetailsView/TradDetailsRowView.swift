//
//  TradDetailsRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/13.
//

import SwiftUI



struct TradDetailsRowView: View
{
    @State private var showConfimDialog = false
    
    var trad: Traduction
    
    var body: some View
    {
        HStack(alignment:.top) {
            Text(trad.langue.flag)
            Text(trad.traductions?.joined(separator: ", ") ?? "Pas de traduction")
        }
        .frame(minHeight:20)
    }
}
