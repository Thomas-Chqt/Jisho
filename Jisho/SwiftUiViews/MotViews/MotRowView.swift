//
//  MotRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/19.
//

import SwiftUI

struct MotRowView: View
{
    @Environment(\.languesPref) var languesPref
    @Environment(\.languesAffichées) var languesAffichées
    
    @StateObject var mot:Mot
    
    
    var body: some View
    {        
        let firstJap = mot.japonais?.first(where: { ($0.kanji != nil) || ($0.kana != nil) })
        let firstSense = mot.senses?.first
        
        VStack(alignment: .leading)
        {
            if firstJap != nil
            {
                japPart
            }
            
            if firstSense != nil
            {
                sensePart
            }
            else
            {
                Text(firstJap != nil ? "Pas de données" : "Pas de senses")
                    .font(firstJap != nil ? .title : .body)
                    .lineLimit(1)
            }
        }
        .frame(height: 70)
    }
    
    var japPart: some View {
        
        let firstJap = mot.japonais!.first(where: { ($0.kanji != nil) || ($0.kana != nil) })!
        
        return HStack
        {
            if let kanji = firstJap.kanji
            {
                Text(kanji).font(.title)
                
                if let kana = firstJap.kana
                {
                    Text("「\(kana)」").lineLimit(1)
                }
            }
            else
            {
                Text(firstJap.kana!).font(.title).lineLimit(1)
            }
        }
    }
    
    var sensePart: some View {
        let firstSense = mot.senses!.first!
        
        let firstTrad = firstSense.traductionsArray?.sorted(languesPref.wrappedValue).first(where: {
            $0.traductions != nil && languesAffichées.wrappedValue.contains($0.langue)
        })
        
        guard let firstTrad = firstTrad else { return Text("Pas de traduction") }
        
        return Text(firstTrad.traductions!.joined(separator: ", "))

    }
}


//struct MotRowView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        List{
//            MotRowView(mot: JMdictMotPreview(importedMot: Mot(type: .preview)))
//        }.listStyle(.inset)
//    }
//}
