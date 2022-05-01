//
//  ModifyJaponaisView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/02.
//

import SwiftUI

struct ModifyJaponaisView: View {
    
    @Binding var japonais:JaponaisStruct
    
    var body: some View
    {
        List
        {
            TextField("Kanji", text: $japonais.kanji)
            TextField("Kana", text: $japonais.kana)
        }
    }
}

//struct ModificationJaponaisView_Previews: PreviewProvider {
//    static var previews: some View {
//        Text("Background")
//            .sheet(isPresented: .constant(true)) {
//                NavigationView {
//                    ModificationJaponaisView(japonais: .constant(JaponaisStruct(.preview)), kanjiTextField: "Kanji")
//                }
//            }
//    }
//}
