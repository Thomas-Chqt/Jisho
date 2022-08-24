//
//  SenseDetailsRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/24.
//

import SwiftUI

struct SenseDetailsRowView: View
{
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var sense:Sense
    
    var body: some View
    {
        let metaDatas = sense.metaDatas
        let trads = sense.traductionsArray?.sortedCompacted(settings)
        
        
        VStack(alignment: .leading, spacing: 5)
        {
            if let metaDatas = metaDatas
            {
                ForEach(Array(metaDatas.enumerated()), id: \.offset ) { offset, metaData in
                    
                    if offset != 0 { Divider() }
                    
                    MetaDataRowView(metaData: metaData) { description in
                        HStack(alignment:.top)
                        {
                            Image(systemName: "info.circle")
                            Text(description)
                                .lineLimit(nil)
                        }
                        .font(.caption)
                        .frame(height: 8)
                    }
                }
            }
            
            if let trads = trads
            {
                ForEach(Array(trads.enumerated()), id: \.offset) { offset, trad in
                    if metaDatas != nil || offset != 0 { Divider() }
                    
                    TradDetailsRowView<AnyView>(trad: trad)
                }
            }
            else
            {
                Text("Pas de traduction")
                    .frame(minHeight:20)
            }
        }
    }
}








//struct SenseRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        List(){
//            Section{
//                SenseRowView(sense: JMdictMotPreview(importedMot: Mot(type: .preview)).senses[0])
//            }
//        }.listStyle(.inset)
//    }
//}
