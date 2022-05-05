//
//  ModifyJapSheetView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/03.
//

import SwiftUI

struct ModifyJapSheetView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var modifiableJaponais: Japonais

    var body: some View {
        List {
            Section("Kanji") {
                TextField("Kanji", text: Binding(get: { modifiableJaponais.kanji ?? "" }, set: { modifiableJaponais.kanji = $0 }))
            }
            
            Section("Kana") {
                TextField("Kana", text: Binding(get: { modifiableJaponais.kana ?? "" }, set: { modifiableJaponais.kana = $0 }))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}










/*
struct ModifyJapSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyJapSheetView()
    }
}
*/
